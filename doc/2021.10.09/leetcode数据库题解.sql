-- 查询employee表中薪资第二高的数据，第一种方式使用limit 限制 ，1 1 从第一个开始，size=1，并使用了ifnull函数
-- 第二种方式 先查出最大值，再找出比最大值小的最大值，就是第二高的了
SELECT IFNULL(
               (SELECT tmp.salary FROM (SELECT DISTINCT salary FROM employee ORDER BY salary DESC LIMIT 1 ,1) tmp) ,NULL
           ) AS SecondHighestSalary;
SELECT MAX(salary) FROM employee WHERE salary < (SELECT MAX(salary) FROM employee);

-- 查找employee表中第n高的薪水，如果不存在，返回null.function的return语句里面不能直接写N -1
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  SET N = N -1;
RETURN (
        - Write your MySQL query statement below.
      SELECT DISTINCT salary FROM employee ORDER BY salary DESC LIMIT N ,1
    );
END;

-- 对 Scores  表进行分数排名 leet code 178
-- rang,row_number,dense_rank都是mysql 8以上的函数
SELECT score ,RANK() OVER(ORDER BY score DESC) FROM scores ; -- 并列排名，并且跳过并列的顺序

SELECT score , ROW_NUMBER() OVER(ORDER BY score DESC) FROM scores; -- 直接顺序排名

SELECT Score , DENSE_RANK() OVER(ORDER BY score DESC) AS `Rank` FROM scores -- 并列排名，不跳过并列的顺序

SELECT score , RANK() OVER(ORDER BY score DESC) AS `rank` FROM scores ORDER BY `rank` DESC;

-- 以下是mysql8以前得实现
-- 直接顺序排名
SELECT score , @rank:=@rank+1 `rank` FROM scores , (SELECT @rank:=0)  q ORDER BY score DESC;

SELECT score , @rank:=@rank+1 `rank` FROM scores , (SELECT @rank:=0) q ORDER BY score DESC;

--并列排名，不跳过并列的顺序，使用 temp_score变量保存上一个连续得分数，，
--使用case when 判断 temp_score和score相等得时候直接用rank，不相等得时候rank+1
SELECT score , CASE WHEN @temp_score=score THEN @rank WHEN  @temp_score:=score THEN  @rank:=@rank+1 END  `rank`
FROM scores , (SELECT @rank:=0,@temp_score:=NULL) q ORDER BY score DESC;


SELECT score , @rank:=IF (@temp_score = score , @rank , @seq) `rank` ,@seq := @seq +1  , @temp_score := score
FROM scores , (SELECT @rank:=0 , @temp_score:=NULL, @seq:=1) q ORDER BY score DESC;

--并列排名，跳过并列得顺序
-- 使用temp_score保存上一个score
-- 使用seq记录下一个元素理论上正常得排序顺序
-- rank变量使用if条件判断当前score和上一个score是否相同，如果相同，使用上一个得排名数字，如果不同，使用seq正常的排序顺序
SELECT score , @rank:= IF(@temp_score=score , @rank , @seq) AS `rank`, @temp_score:= score , @seq:=@seq + 1
FROM scores,(SELECT @rank:=0 ,@temp_score:=NULL , @seq:=1) q ORDER BY score DESC;


--leetcode 181题，超过经理收入的员工
-- 先通过left join 关联两个 employee 表，找出每一个员工对应的经理的信息，然后在重新生成的表上对比salary
SELECT staffname AS Employee FROM (SELECT e1.name AS staffname,e1.salary AS satffsalary,e2.name AS managername,e2.salary AS managersalary FROM employee e1
                                                                                                                                                   LEFT JOIN employee e2 ON e1.managerid = e2.id) relation WHERE relation.satffsalary > relation.managersalary

    --leetcode
SELECT NAME AS customers FROM customers WHERE  customers.id NOT IN (SELECT customerid FROM orders);


--leetcode 196 ， 删除重复的电子邮箱
-- 不使用delete方法
SELECT MIN(id), email FROM person_182 GROUP BY email;
-- 使用delete方法
DELETE FROM person_182 WHERE id NOT IN (SELECT t.id FROM (SELECT MIN(id) AS id FROM person_182 GROUP BY email) t);


--leetcode 197 上升的温度
-- 使用 date_add 函数 找出所有日期的前一天，两个表进行关联比较
SELECT las.id FROM weather w ,
                   (SELECT id , DATE_ADD(RecordDate , INTERVAL -1 DAY) AS lastday ,Temperature  FROM weather w1 ORDER BY recorddate DESC) las
WHERE w.recorddate = las.lastday AND las.Temperature > w.Temperature;

-- 使用datediff函数，
--  datediff(日期1, 日期2)： 得到的结果是日期1与日期2相差的天数。
-- 该例中，让两个日期之间的天数相差 正1，那就代表 a表中的日期，在b表中的日期之前，如果a的温度也大于b的温度，则结果正确
SELECT a.id FROM weather AS a JOIN weather AS b ON a.temperature > b.temperature AND DATEDIFF(a.recorddate,b.recorddate) = 1;


-- leetcode184 部门工资最高的员工
-- 普通的用法
SELECT depart.name  AS Department  , emp.name AS Employee , emp.salary AS Salary  FROM employee_184 emp ,
                                                                                       (SELECT departmentid , MAX(salary) maxsalary FROM employee_184 GROUP BY departmentid) tmp ,
                                                                                       department_184 depart
WHERE emp.departmentid = tmp.departmentid AND tmp.maxsalary = emp.salary AND depart.id = tmp.departmentid;

--使用 开窗函数 , 使用开窗函数可以计算出每个的排名，不仅可以取最高，还可以取第二、第三等
SELECT department.name AS Department , tmp.name AS Employee ,tmp.salary AS Salary FROM department_184 AS department ,
                                                                                       (SELECT NAME, departmentid , salary ,
                                                                                               DENSE_RANK() OVER(PARTITION BY departmentid ORDER BY salary DESC) AS `rank` FROM employee_184 ) tmp
WHERE department.id =tmp.departmentid AND tmp.rank = 1;


-- leetcode 180 连续出现的数字，找出所有至少连续出现三次的数字
-- 第一种写法，保证id连续 ，一定要用inner join ，后两个表的连续后两个id都和当前的id相等，就是至少三个了
SELECT DISTINCT(a.num) AS ConsecutiveNums  FROM LOGS a INNER JOIN LOGS b ON a.num = b.num AND a.id+1=b.id
                                                       INNER JOIN LOGS c ON a.num = c.num AND a.id+2=c.i;

-- 第二种写法，使用变量的方式，如果该数字连续出现，则从1一直累加，中断，重新从1计数，再出现连续再从1累加，最后查出连续数字大于3 的
SELECT DISTINCT num FROM (SELECT num , IF(@temp_num=num , @seq:=@seq+1 , @seq:=1) AS seq, @temp_num:=num AS temp_num
                          FROM LOGS , (SELECT @temp_num:=NULL , @seq=1) q) seq_table WHERE seq_table.seq >= 3


    --leetcode 596
SELECT class FROM (SELECT DISTINCT student ,class FROM courses_596) tmp_classes GROUP BY class HAVING COUNT(*) >= 5

    --leetcode 627 性别变更，只使用单个update，不适用select
UPDATE salary_627 SET sex = (CASE WHEN sex='m' THEN 'f' ELSE 'm' END);

-- leetcode 620
SELECT * FROM cinema_620 WHERE `description` != 'boring' AND id%2=1 ORDER BY rating DESC

    -- leetcode 626 换座位
    -- id连续递增，两个相邻的位置交换名称，最后如果是奇数列，名字不变

    -- 第一种写法
    -- case when 里面 进行 id奇偶的判定，如果是奇数查询下一个id的名字，否则查询上一个id的名字，if是奇数 最后一个为null，那么取他本来的名字
SELECT newseat.id , IFNULL(newseat.student,(SELECT se.student FROM seat_626 se WHERE se.id = newseat.id))
FROM
    (SELECT a.id , (CASE WHEN a.id%2=1 THEN (SELECT tmp.student FROM seat_626 tmp WHERE tmp.id = a.id+1)
                         ELSE (SELECT tmp.student FROM seat_626 tmp WHERE tmp.id = a.id-1) END) AS student FROM seat_626 a) newseat;
-- 第一种写法的变形
SELECT a.id , IFNULL(
        (CASE WHEN a.id%2=1 THEN (SELECT tmp.student FROM seat_626 tmp WHERE tmp.id = a.id+1)
              ELSE (SELECT tmp.student FROM seat_626 tmp WHERE tmp.id = a.id-1) END) ,(SELECT b.student FROM seat_626 b WHERE b.id = a.id)) AS student
FROM seat_626 a


    -- 第二种 使用开窗函数
-- 对id做排名计算，计算id排名的时候 if 是偶数 则 将其-1，如果是奇数则+1 ，例如，原来id=1，if判断后为2，id=2，if判断后为1，最终排名为 id=2,id=1
-- 最终输出的时候
SELECT id ,ROW_NUMBER() OVER(ORDER BY IF(id%2=0,id-1,id+1)) AS `rank`, student FROM seat_626

                                                                                        - leetcode 262
-- 查出 2013-10-01 至 2013-10-03 期间 非禁止用户(乘客和司机都要禁止)的取消率(用户取消和司机取消都可以)
-- leetcode ac通过
-- 最后用取消状态的最大值(总共取消的天数)/日期的总数即可
SELECT request_at AS `Day` , ROUND(MAX(cnt)/COUNT(1),2)   AS `Cancellation Rate` FROM (
                                                                                          - 根据非禁止用户的订单状态，判断每天取消状态的总数
	-- if判断不能写在第一个查询里面，因为第一个查询先不是按照顺序的，会出现计算取消总数出现误差
	SELECT request_at,IF(STATUS IN ('cancelled_by_driver','cancelled_by_client' ),@cancel:=@cancel+1,@cancel:=0) AS cnt FROM
	(
	-- 这个是查出来日期范围内所有非禁止用户的订单的状态
	SELECT request_at ,STATUS
	FROM trips , (SELECT @cancel:=0) q WHERE request_at BETWEEN '2013-10-01' AND '2013-10-03'
	AND client_id IN (SELECT users_id FROM users WHERE banned = 'no' )
	AND driver_id IN (SELECT users_id FROM users WHERE banned = 'no' ) ORDER BY request_at, STATUS) AS daa) AS tmp GROUP BY request_at;

-- leetcode 185
-- 查询 部门工资前三的姓名、工资、部门信息
-- 第一种方式，使用开窗函数 dense_over 按部门分组，按工资排序，找出 排名数小于三的即可
SELECT m.department , m.employee , m.salary FROM (
                                                     SELECT t.* , DENSE_RANK() OVER(PARTITION BY t.department ORDER BY t.salary DESC) AS `rank` FROM
                                                         (SELECT de.name AS department ,em.name AS Employee  ,em.salary FROM employee_185 em LEFT JOIN department_185 de ON em.departmentid = de.id ORDER BY em.departmentid , em.salary DESC) t
                                                 ) AS m WHERE m.`rank` <=3;
-- 第二种方式，不使用开窗函数,自己手动实现排名的方式
SELECT m.department,m.employee,m.salary FROM (
                                                 SELECT t.department , t.employee, t.salary , IF (@depart=t.department,IF (@tmp_salary=t.salary,@rank,@rank:=@rank+1),@rank:=1) AS `rank` , @depart:=t.department , @tmp_salary:=t.salary
                                                 FROM
                                                     (SELECT de.name AS department ,em.name AS Employee  ,em.salary
                                                     FROM employee_185 em LEFT JOIN department_185 de ON em.departmentid = de.id
                                                     ORDER BY em.departmentid , em.salary DESC) t , (SELECT @rank:=0,@depart:=NULL,@tmp_salary:=NULL) q) m WHERE m.`rank` <= 3 ;

-- 第三种方式，使用 同表 相连 得方式。(但这里面 having count 里面得 distinct salary 就很令人迷惑，有些情况 使用( e2.salary) <= 3 正确，但只有一个 depart，
-- 结果就不正确，只能用 (DISTINCT e2.salary) <= 2 , 此处还有待研究).
-- 但这种方式里面得内链接在数据多得情况下，可能耗时比较严重
-- 首先，同样的两个表根据departmentid相连，找出和左表departmentid相匹配的右表的数据，找出右表中比左表salary高的数据，
-- 按这个筛选出来的结果，按左表的id进行分组，右表的数量在两个以内就说明我是第三名甚至更高
SELECT  de.name AS department ,em.name AS employee, em.salary FROM employee_185 em LEFT JOIN department_185 AS de ON em.departmentid = de.id WHERE em.id IN (
    SELECT e1.id FROM employee_185 AS e1 LEFT JOIN employee_185 AS e2 ON e1.DepartmentId = e2.DepartmentId AND e1.salary < e2.salary
    GROUP BY e1.id  HAVING COUNT(DISTINCT e2.salary) <= 2) ORDER BY de.id , em.salary DESC;



-- leet_code601 找出人数大于或等于100且id连续的三行或更多记录
-- 第一个条件 人数范围，第二个条件 id连续
-- 第一种方式(自己写的)
-- SELECT sta.* , IF (id=@tmp_id,id-@seq:=@seq+1,id-@seq:=1) AS seq,@seq AS `rank`, @tmp_id:=id+1  FROM stadium_601 sta , (SELECT @seq:=1 , @tmp_id:=NULL) q WHERE people > 100
    -- 主要是通过 id连续进行排名，id有多少个连续的，排名就会依次上升，直到不连续id，重新从1开始。seq代表id和rank的差值，连续的id，使用id-seq结果相同
    -- 最终通过group by having count 查出数量大于3个的结果
SELECT p.id ,visit_date,people FROM
                                   (SELECT seq  FROM (
                                                         SELECT sta.* , IF (id=@tmp_id,id-@seq:=@seq+1,id-@seq:=1) AS seq,@seq AS `rank`, @tmp_id:=id+1  FROM stadium_601 sta , (SELECT @seq:=1 , @tmp_id:=NULL) q WHERE people > 100
                                                     ) AS m GROUP BY seq HAVING COUNT(*)>=3) AS t,
                                   (SELECT sta.* , IF (id=@tmp_id,id-@seq:=@seq+1,id-@seq:=1) AS seq,@seq AS `rank`, @tmp_id:=id+1  FROM stadium_601 sta , (SELECT @seq:=1 , @tmp_id:=NULL) q WHERE people > 100
                                   ) AS p WHERE t.seq = p.seq;

-- 上一个结果的转换
-- 在排名的结果上，使用 count(*) over(partition by seq) 按seq分组查询出分组的总数,每一行都会带有分组的总数
SELECT id , visit_date , people FROM (
                                         SELECT id ,visit_date,people , COUNT(*) OVER(PARTITION BY seq) k FROM (
                                                                                                                   SELECT sta.* , IF (id=@tmp_id,id-@seq:=@seq+1,id-@seq:=1) AS seq,@seq AS `rank`, @tmp_id:=id+1  FROM stadium_601 sta , (SELECT @seq:=1 , @tmp_id:=NULL) q WHERE people >= 100
                                                                                                               ) AS m ) p WHERE p.k >= 3 ;

-- 评论的方式，可以使用 id-rownumber 的方式，先查询出 people>=100 的数据，然后计算id-该id所在的行号，根据这个结果判断是不是连续的
SELECT id , visit_date , people FROM (
                                         SELECT id , visit_date,people,COUNT(*) OVER(PARTITION BY k1) k2 FROM (
                                                                                                                  SELECT id,visit_date,people,id-ROW_NUMBER()OVER(ORDER BY visit_date) k1 FROM stadium_601  -2.按日期排序 用id-row_number 的方式判断是否连续
                                                                                                                  WHERE people>=100) t ) p WHERE p.k2 >= 3;


-- leetcode 1179 经典行转列问题
-- 行转列问题，需要对数据 按条件进行group by ，然后每一个id的内容，都是用聚合函数，并使用case when 进行重新标记列名称
SELECT id ,SUM(CASE `month` WHEN 'Jan' THEN revenue ELSE NULL END) AS `Jan_Revenue`,
       SUM(CASE `month` WHEN 'Feb' THEN revenue ELSE NULL END) AS `Feb_Revenue`,
       SUM(CASE `month` WHEN 'Mar' THEN revenue ELSE NULL END) AS `Mar_Revenue`,
       SUM(CASE `month` WHEN 'Apr' THEN revenue ELSE NULL END) AS `Apr_Revenue`,
       SUM(CASE `month` WHEN 'May' THEN revenue ELSE NULL END) AS `May_Revenue`,
       SUM(CASE `month` WHEN 'Jun' THEN revenue ELSE NULL END) AS `Jun_Revenue`,
       SUM(CASE `month` WHEN 'Jul' THEN revenue ELSE NULL END) AS `Jul_Revenue`,
       SUM(CASE `month` WHEN 'Aug' THEN revenue ELSE NULL END) AS `Aug_Revenue`,
       SUM(CASE `month` WHEN 'Sep' THEN revenue ELSE NULL END) AS `Sep_Revenue`,
       SUM(CASE `month` WHEN 'Oct' THEN revenue ELSE NULL END) AS `Oct_Revenue`,
       SUM(CASE `month` WHEN 'Nov' THEN revenue ELSE NULL END) AS `Nov_Revenue`,
       SUM(CASE `month` WHEN 'Dec' THEN revenue ELSE NULL END) AS `Dec_Revenue`
FROM department_1179 GROUP BY id;








