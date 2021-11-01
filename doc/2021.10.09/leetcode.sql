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
    -- Write your MySQL query statement below.
    SELECT DISTINCT salary FROM employee ORDER BY salary DESC LIMIT N ,1
    );
END;

-- 对 Scores  表进行分数排名 leet code 178
-- rang,row_number,dense_rank都是mysql 8以上的函数
SELECT score ,RANK() OVER(ORDER BY score DESC) FROM scores ; -- 并列排名，并且跳过并列的顺序,会出现并列

SELECT score , ROW_NUMBER() OVER(ORDER BY score DESC) FROM scores; -- 直接顺序排名

SELECT Score , DENSE_RANK() OVER(ORDER BY score DESC) AS `Rank` FROM scores -- 并列排名，不跳过并列的顺序

SELECT score , RANK() OVER(ORDER BY score DESC) AS `rank` FROM scores ORDER BY `rank` DESC;

-- 以下是mysql8以前得实现
-- 直接顺序排名
SELECT score , @rank:=@rank+1 `rank` FROM scores , (SELECT @rank:=0)  q ORDER BY score DESC;

SELECT score , @rank:=@rank+1 `rank` FROM scores , (SELECT @rank:=0) q ORDER BY score DESC;

-- 并列排名，不跳过并列的顺序，使用 temp_score变量保存上一个连续得分数，，
-- 使用case when 判断 temp_score和score相等得时候直接用rank，不相等得时候rank+1
SELECT score , CASE WHEN @temp_score=score THEN @rank WHEN  @temp_score:=score THEN  @rank:=@rank+1 END  `rank`
FROM scores , (SELECT @rank:=0,@temp_score:=NULL) q ORDER BY score DESC;


SELECT score , @rank:=IF (@temp_score = score , @rank , @seq) `rank` ,@seq := @seq +1  , @temp_score := score
FROM scores , (SELECT @rank:=0 , @temp_score:=NULL, @seq:=1) q ORDER BY score DESC;

-- 并列排名，跳过并列得顺序
-- 使用temp_score保存上一个score
-- 使用seq记录下一个元素理论上正常得排序顺序
-- rank变量使用if条件判断当前score和上一个score是否相同，如果相同，使用上一个得排名数字，如果不同，使用seq正常的排序顺序
SELECT score , @rank:= IF(@temp_score=score , @rank , @seq) AS `rank`, @temp_score:= score , @seq:=@seq + 1
FROM scores,(SELECT @rank:=0 ,@temp_score:=NULL , @seq:=1) q ORDER BY score DESC;


-- leetcode 181题，超过经理收入的员工
--  先通过left join 关联两个 employee 表，找出每一个员工对应的经理的信息，然后在重新生成的表上对比salary
SELECT staffname AS Employee FROM (SELECT e1.name AS staffname,e1.salary AS satffsalary,e2.name AS managername,e2.salary AS managersalary FROM employee e1
                                                                                                                                                   LEFT JOIN employee e2 ON e1.managerid = e2.id) relation WHERE relation.satffsalary > relation.managersalary

-- leetcode
SELECT NAME AS customers FROM customers WHERE  customers.id NOT IN (SELECT customerid FROM orders);


-- leetcode 196 ， 删除重复的电子邮箱
-- 不使用delete方法
SELECT MIN(id), email FROM person_182 GROUP BY email;
-- 使用delete方法
DELETE FROM person_182 WHERE id NOT IN (SELECT t.id FROM (SELECT MIN(id) AS id FROM person_182 GROUP BY email) t);


-- leetcode 197 上升的温度
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

-- 使用 开窗函数 , 使用开窗函数可以计算出每个的排名，不仅可以取最高，还可以取第二、第三等
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


-- leetcode 596
SELECT class FROM (SELECT DISTINCT student ,class FROM courses_596) tmp_classes GROUP BY class HAVING COUNT(*) >= 5

-- leetcode 627 性别变更，只使用单个update，不适用select
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

-- leetcode 262
-- 查出 2013-10-01 至 2013-10-03 期间 非禁止用户(乘客和司机都要禁止)的取消率(用户取消和司机取消都可以)
-- leetcode ac通过
-- 最后用取消状态的最大值(总共取消的天数)/日期的总数即可
SELECT request_at AS `Day` , ROUND(MAX(cnt)/COUNT(1),2)   AS `Cancellation Rate` FROM (
                                                                                          -- 根据非禁止用户的订单状态，判断每天取消状态的总数
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
                                                                                                                  SELECT id,visit_date,people,id-ROW_NUMBER()OVER(ORDER BY visit_date) k1 FROM stadium_601  -- 2.按日期排序 用id-row_number 的方式判断是否连续
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

-- leetcode511 查询每位玩家第一次登陆平台的日期
SELECT player_id , MIN(event_date) FROM activity_511 GROUP BY player_id;
-- 窗口函数实现 时间比上一个快一点
SELECT DISTINCT player_id , MIN(event_date) OVER(PARTITION BY player_id) FROM activity_511;

-- leetcode512 查询每位玩家第一次登陆平台的设备
SELECT b.player_id ,b.device_id FROM
                                    (SELECT DISTINCT player_id , MIN(event_date) OVER(PARTITION BY player_id) AS event_date FROM activity_511 ) a , activity_511 b
WHERE a.player_id = b.player_id AND a.event_date = b.event_date;


-- leetcode 534
-- 报告每组玩家和日期，以及截止到日期为止，玩了多少游戏
-- 个人解法。使用排名得方式，先按照相同的用户排名，每个用于出现的次数就是1，2，3，1，2这样
-- 然后 使用@rank ,初始为1，如果@rank=用户的排名，说明是一个用户，tmp_score相加，
-- 否则 如果 ra=1 (因为@rank是一直增加的，如果第一个用户结束，到第二个用户的时候，此时ra还是1，但这是rank可能是4，所以需要单独判断一下)，tmp_score为0+games_played
-- 最后要增加rank的值，如果ra是1，直接让rank变成2，否则自增+1
SELECT player_id , event_date , games_played ,games_played_so_far FROM
    (SELECT player_id , event_date , games_played
          ,IF (@rank=ra,@tmp_score:=@tmp_score+games_played,IF(ra=1,@tmp_score:=0+games_played,@rank:=0))  AS games_played_so_far
          , IF (ra=1,@rank:=2,@rank:=@rank+1)
     FROM (
              SELECT player_id , event_date ,games_played, RANK() OVER (PARTITION BY player_id ORDER BY event_date) AS ra
              FROM activity_511 acti ORDER BY player_id , event_date
          ) tt , (SELECT @rank:=1 , @tmp_score:=0) q ) aa;

-- 第二种，直接使用 sum() over()窗口函数
SELECT player_id,event_date , SUM(games_played) OVER(PARTITION BY player_id ORDER BY event_date) FROM activity_511 ORDER BY player_id , event_date;

-- leetcode 550 报告在首次登录的第二天再次登录的玩家的比率，四舍五入到小数点后两位。
-- 换句话说，您需要计算从首次登录日期开始至少连续两天登录的玩家的数量，然后除以玩家总数。
-- 下面这种实现是通过 两表 and连接
SELECT ROUND(COUNT(1)/(SELECT COUNT(DISTINCT player_id) FROM activity_511),2) AS fraction FROM activity_511 b, (
    SELECT DISTINCT player_id , DATE_ADD(MIN(event_date) OVER(PARTITION BY player_id),INTERVAL 1 DAY) AS event_date FROM activity_511 ) a
WHERE a.player_id = b.player_id AND a.event_date = b.event_date
-- 下面这种实现是通过 in。使用两个字段in
SELECT ROUND(COUNT(1)/(SELECT COUNT(DISTINCT player_id) FROM activity_511),2) AS fraction FROM activity_511 WHERE (player_id,event_date) IN
                                                                                                                  (SELECT DISTINCT player_id , DATE_ADD(MIN(event_date) OVER(PARTITION BY player_id),INTERVAL 1 DAY) AS event_date FROM activity_511 ) ;


-- leetcode 569 , 求员工薪水的中位数
-- tmp1临时表，按公司查询出其中位数应该是哪些
-- tmp2临时表，根据 salary、compnay进行排序，并标记出排名情况
-- 根据公司和排名条件相等查询出结果
SELECT tmp2.id,tmp2.company,tmp2.salary FROM
                                            (SELECT company,CAST(IF(cnt%2=0,cnt/2,(cnt+1)/2) AS SIGNED) AS acnt,
                                                    CAST(IF(cnt%2=0,(cnt+2)/2,(cnt+1)/2)  AS SIGNED) AS bcnt FROM (SELECT company,COUNT(1) AS cnt FROM employee_569 GROUP BY company) ca_count) tmp1,
                                            (SELECT id , company , salary , IF(@tmp_ca=company,@rank:=@rank+1,@rank:=1) AS `rank` ,@tmp_ca:=company
                                             FROM employee_569 , (SELECT @rank:=1,@tmp_salary:=NULL , @tmp_ca:=NULL) q ORDER BY company,salary) tmp2
WHERE tmp1.company = tmp2.company AND (tmp1.acnt = tmp2.`rank` OR tmp1.bcnt = tmp2.`rank`);

-- 使用开窗函数解决
SELECT company,COUNT(1) FROM employee_569 , GROUP BY company;
SELECT id , company , salary ,ran FROM (
                                           SELECT id , ROW_NUMBER() OVER (PARTITION BY company ORDER BY salary ) ran ,
                                                  COUNT(id) OVER(PARTITION BY company) cnt,
                                                  company,salary
                                           FROM employee_569) tmp
WHERE tmp.ran IN (FLOOR((tmp.cnt+1)/2),FLOOR((tmp.cnt+2)/2)) ;

-- leetcode 570
-- 查询至少有5名直接下属的经理
SELECT a.`name` FROM employee_570 a,
                     (SELECT managerid FROM employee_570 WHERE managerId IS NOT NULL GROUP BY managerId HAVING COUNT(*) >=5) p WHERE a.id = p.managerid;

-- leetcode 571
-- 查找所有数字的中位数，表中只保存了数字和其对应的频率
-- 整体思路 tmp1 临时表是 整个数据中，中位数应该在第几个位置
-- tmp2 临时表是数字、频率、截至目前的总数量
-- where的判断是 目前的总数量-中位数 < 频率 并且 中位数 < 目前的总数量
-- 写两遍 并 join的原因 是要 让 两个中位数 都取出来，最后直接进行 加和/2
SELECT (number1+number2)/2 AS   MEDIAN FROM
    ( SELECT tmp2.`number` AS number1
      FROM
          (SELECT DISTINCT FLOOR((SUM(frequency) OVER() +1)/2) AS a FROM numbers) tmp1,
          (SELECT `number`,frequency,SUM(frequency) OVER(ORDER BY NUMBER) AS su FROM numbers ) tmp2
      WHERE ((tmp2.su-tmp1.a)<tmp2.frequency AND tmp1.a<=tmp2.su) ) p1 JOIN
    ( SELECT tmp2.`number` AS number2
      FROM
          (SELECT DISTINCT FLOOR((SUM(frequency) OVER() +2)/2) AS a FROM numbers) tmp1,
          (SELECT `number`,frequency,SUM(frequency) OVER(ORDER BY NUMBER) AS su FROM numbers ) tmp2
      WHERE ((tmp2.su-tmp1.a)<tmp2.frequency AND tmp1.a<=tmp2.su)) p2;


-- leetcode 574 当选者
-- vote表中重复得candidateid最多得
SELECT can.name FROM candidate_574 can , (
    SELECT candidateid, COUNT(1) AS cnt FROM vote_574 GROUP BY candidateid ORDER BY cnt DESC LIMIT 1) p
WHERE can.id = p.candidateid;

-- leet577 bonus < 1000 的员工name及其 bonus
SELECT em.name,bo.bonus FROM employee_577 em LEFT JOIN bonus_577 bo ON bo.empid = em.empid
WHERE em.empid NOT IN ( SELECT empid  FROM bonus_577 WHERE bonus >= 1000);

SELECT em.name,bo.bonus FROM employee_577 em LEFT JOIN bonus_577 bo ON bo.empid = em.empid
WHERE bonus < 1000 OR bonus IS NULL;


-- leetcode 578 查询回答率最高的问题
-- 查看数据和 回答率的含义，其实就是 要算出相同问题的回答数占显示数的比率，没有出现q_num会话相关筛选也是可以的
SELECT DISTINCT a.question_id AS survey_log FROM
    (
        SELECT show_tmp.question_id , IFNULL( ans_tmp.answer_cnt,0)/IFNULL(show_tmp.show_cnt,1) answer_lv FROM
            (SELECT question_id , COUNT(*) AS show_cnt  FROM survey_log_578 WHERE ACTION = 'show' GROUP BY question_id) show_tmp
                LEFT JOIN
            (SELECT question_id , COUNT(*) AS answer_cnt FROM survey_log_578 WHERE ACTION = 'answer' GROUP BY question_id) ans_tmp
            ON show_tmp.question_id = ans_tmp.question_id ORDER BY answer_lv DESC LIMIT 1
    ) b  LEFT JOIN survey_log_578 a
                   ON a.question_id = b.question_id  AND a.action='answer';

-- 更简单的写法
SELECT question_id AS survey_log FROM survey_log_578 GROUP BY question_id ORDER BY SUM(ACTION='answer')/SUM(ACTION='show') DESC LIMIT 1;


-- leetcode 579 查询员工的累计薪水
-- 编写 SQL 语句，对于每个员工，查询他除最近一个月（即最大月）之外，剩下每个月的近三个月的累计薪水（不足三个月也要计算)
-- 如用户1，1，2，3，4月分别对应1，2，3，4所以结果应该为(1,1),(2,1+2),(3,1+2+3)
-- 最外层查询结果，salary用当前的salary和往前两个月的结果
SELECT id ,MONTH,
    salary +
    IFNULL((SELECT salary FROM employee_579 b WHERE a.id=b.id AND b.month = a.`month`-1),0) +
    IFNULL((SELECT salary FROM employee_579 b WHERE a.id=b.id AND b.month = IF(a.`month`=1,0,a.month-2)),0) salary
FROM (
-- 按用户和月份进行排序，结果不包含用户最大的那个月份
    SELECT  e.id , e.MONTH, e.salary , RANK() OVER(PARTITION BY e.id ORDER BY MONTH) `rank`
    FROM employee_579  e,
-- max里面找出来每个用户最大的月份
    (SELECT id , MAX(MONTH) max_month FROM employee_579  GROUP BY id) b WHERE e.id=b.id AND  b.max_month!=e.month
    ) a ORDER BY id ASC , MONTH DESC;

-- sum(field) over() 窗口函数求和，rows 2 preceding 计算求和的偏移，偏移两个计算求和的结果 ,但是 rows是连续两个，此处应该使用range，范围内
SELECT id, MONTH , salary , SUM(salary) OVER(PARTITION BY id ORDER BY MONTH ROWS 2 PRECEDING) FROM employee_579 ORDER BY id ASC , MONTH DESC;


-- leetcode 580 统计各专业学生人数
SELECT b.dept_name,IFNULL(cnt,0) AS student_number FROM department_580 b LEFT JOIN
                                                        (SELECT dept_id,COUNT(1) AS cnt FROM student_580 GROUP BY dept_id ORDER BY cnt) c ON b.dept_id = c.dept_id ORDER BY c.cnt DESC ,b.dept_name ASC;

SELECT b.dept_name,COUNT(a.student_name) AS student_number
FROM department_580 b LEFT JOIN student_580 a ON b.dept_id = a.dept_id GROUP BY b.dept_id;

-- leetcode 585 2016年的投资
-- 写一个查询语句，将 2016 年 (TIV_2016) 所有成功投资的金额加起来，保留 2 位小数。
-- 对于一个投保人，他在 2016 年成功投资的条件是：
-- 他在 2015 年的投保额 (TIV_2015) 至少跟一个其他投保人在 2015 年的投保额相同。
-- 他所在的城市必须与其他投保人都不同（也就是说维度和经度不能跟其他任何一个投保人完全相同）。
-- 两个in 分别是 投保金额相同的，和 经纬度相同的。需要满足金额相同，但是经纬度不同。该方法的执行时间较长
SELECT SUM(tiv_2016) AS TIV_2016 FROM insurance_585
WHERE tiv_2015 IN (SELECT tiv_2015 FROM insurance_585 GROUP BY tiv_2015 HAVING COUNT(*) >=2)
  AND (lat,lon) NOT IN (SELECT lat,lon FROM insurance_585 GROUP BY lat,lon HAVING COUNT(*) >= 2);
-- 都是in就快了。把第二个的 >=2 换成=1，只要 经纬度的分组是一个的即可
SELECT SUM(tiv_2016) AS TIV_2016 FROM insurance_585
WHERE tiv_2015 IN (SELECT tiv_2015 FROM insurance_585 GROUP BY tiv_2015 HAVING COUNT(*) >=2)
  AND (lat,lon)  IN (SELECT lat,lon FROM insurance_585 GROUP BY lat,lon HAVING COUNT(*)=1);

-- 使用窗口函数
SELECT SUM(tiv_2016) AS tiv_2016 FROM
    (SELECT * , COUNT(*) OVER(PARTITION BY tiv_2015) AS a1 , COUNT(*) OVER(PARTITION BY lat,lon) AS a2 FROM insurance) b
WHERE b.a1>=2 AND b.a2=1;

-- leetcode 597 总体通过率
-- 求出好友申请的通过率，用 2 位小数表示。通过率由接受好友申请的数目除以申请总数。
SELECT IFNULL(ROUND(a.accept/b.send,2),0.00) AS accept_rate FROM
                                                                (SELECT COUNT(DISTINCT requester_id,accepter_id) accept FROM requestAccepted_597) AS a,
                                                                (SELECT COUNT(DISTINCT sender_id,send_to_id) send FROM FriendRequest_597) AS b;

-- leetcode602 谁有最多的好友
-- 保证拥有最多好友数目的只有 1 个人。
-- 好友申请只会被接受一次，所以不会有 requester_id 和 accepter_id 值都相同的重复记录。
-- 按照题目给出的数据情况，先按requester_id聚合，求总数，在按accepter_id聚合求总数，让两个结果通过union all形成一整列的情况
-- 然后按照group by分组，人数排序
SELECT id , SUM(num) AS num FROM
    (SELECT id , cnt AS num
     FROM
         (SELECT requester_id AS id,COUNT(1) AS cnt FROM request_accepted_602 GROUP BY requester_id) AS a
     UNION ALL
     (SELECT accepter_id AS id,COUNT(1) AS cnt FROM request_accepted_602 GROUP BY accepter_id) ) p GROUP BY id ORDER BY SUM(num) DESC LIMIT 1;


-- leetcode603 连续空余座位 1代表空余
-- 思路和之前有个题一样，判断id和当前行数的差值，然后按差值统计总数，找出总数大于等于2的，用到了count() over窗口函数
SELECT seat_id FROM (SELECT seat_id ,COUNT(*) OVER(PARTITION BY k1) k2 FROM
    (SELECT seat_id , (seat_id - ROW_NUMBER() OVER()) AS k1 FROM cinema_603 WHERE free = 1) p ) t WHERE k2>=2;

-- leetcode 608 判断树节点
-- 如果是根，就用root，即 p_id 是null
-- 如果不是根节点，同时还有其他的子节点，就是 Inner，代表 p_id中有该id
-- 如果节点在p_id中不存在，那么就是叶子节点

-- union all的第一个表是查出 根节点和inner节点，如果是这两类，那么在p_id中一定有
-- union all的第二个表即为 叶子节点，同时如果结果中的P_id为null，则代表整棵树只有一个根节点
SELECT * FROM (SELECT DISTINCT t1.id , IF(t1.p_id IS NULL,'Root','Inner') AS TYPE
               FROM tree_608 t1 , tree_608 t2 WHERE t1.id = t2.p_id) a UNION ALL
(
    SELECT  id ,IF(p_id IS NULL,'Root','Leaf') AS TYPE FROM tree_608
    WHERE id NOT IN (SELECT DISTINCT t1.id  FROM tree_608 t1 , tree_608 t2 WHERE t1.id = t2.p_id));

-- 其他方式
-- 使用case when方式，第二个when的地方不能使用 in not in ，如果not in里面的数据有 null数据，那么整体其实都会返回false
SELECT id ,
       CASE WHEN p_id IS NULL THEN 'ROOT'
            WHEN id  IN (SELECT p_id FROM tree_608) THEN 'Inner'
            ELSE 'Leaf'
           END AS TYPE
FROM tree_608 t1;


-- leetcode 610 判断三角形
SELECT X,Y,z,IF(X+Y>z AND Y+z>X AND X+z>Y,'Yes','No') AS triangle FROM triangle_610


-- leetcode 612 平面上最近的距离
-- 表 point_2d 保存了所有点（多于 2 个点）的坐标 (x,y) ，这些点在平面上两两不重合。
-- 写一个查询语句找到两点之间的最近距离，保留 2 位小数
-- 自己的写法，两个同表相join，得到笛卡儿积，分别计算 x到x、y到y、根号的距离，找出不等于null的最小值，但可能因为笛卡儿积，最后执行时间比较长
-- 第一版写的时候，计算sqrt的时候加上了abs，正确的是不应该加上的，错误的写法 ROUND(SQRT(POWER(ABS(a.x)-ABS(b.x),2)+POWER(ABS(a.y)-ABS(b.y),2)),2)
SELECT MIN(dis) AS shortest
FROM
    (
        SELECT CASE WHEN a.x!=b.x AND a.y=b.y THEN ABS(a.x-b.x)
	    WHEN a.y!=b.y AND a.x=b.x THEN ABS(a.y-b.y)
	    WHEN a.x!=b.x AND a.y!=b.y THEN ROUND(SQRT(POWER(a.x-b.x,2)+POWER(a.y-b.y,2)),2)
	    WHEN a.x = b.x AND a.y = b.y THEN NULL
	    END dis
        FROM  point_2d_612 a JOIN point_2d_612 b
    ) p WHERE dis IS NOT NULL ;

-- 可以用向量的方式直接去掉 笛卡儿积之后 相同的数据对
-- 计算距离直接使用笛卡儿积即可
SELECT ROUND(MIN(SQRT(POWER(a.x-b.x,2)+POWER(a.y-b.y,2))),2) AS shortest
FROM  point_2d_612 a JOIN point_2d_612 b ON (a.x,a.y) <> (b.x,b.y) -- (,) <> (,)

-- leetcode 614
-- 对每个关注者，查询关注他的关注者的数目
-- 就是 follower去重，然后再followee列找出 follower对应的数量，同时需要对表先做一次去重处理
SELECT followee , COUNT(1) AS num FROM (SELECT DISTINCT followee,follower FROM follow_614) p
WHERE followee IN (SELECT DISTINCT follower FROM follow_614) GROUP BY followee

-- leetcode 615
-- 写一个查询语句，求出在每一个工资发放日，每个部门的平均工资与公司的平均工资的比较结果 （高 / 低 / 相同）。
-- 在三月，公司的平均工资是 (9000+6000+10000)/3 = 8333.33...
-- 由于部门 '1' 里只有一个 employee_id 为 '1' 的员工，所以部门 '1' 的平均工资就是此人的工资 9000 。因为 9000 > 8333.33 ，所以比较结果是 'higher'。
-- 第二个部门的平均工资为 employee_id 为 '2' 和 '3' 两个人的平均工资，为 (6000+10000)/2=8000 。因为 8000 < 8333.33 ，所以比较结果是 'lower' 。
-- 在二月用同样的公式求平均工资并比较，比较结果为 'same' ，因为部门 '1' 和部门 '2' 的平均工资与公司的平均工资相同，都是 7000 。

-- 子查询中直接通过 avg() over窗口函数、sum() over窗口函数、count() over窗口函数计算出  月的平均amount、每个月按部门的总amount，每个月按部门的count，
-- 最后用case when进行比较 月平均数和按部门和月的平均数大小，取高低，
-- 这个地方注意，之前在子查询中得到了 SUM(sa.amount) OVER(PARTITION BY em.department_id,LEFT(sa.pay_date,7)))
--  和 (COUNT(*) OVER(PARTITION BY em.department_id,LEFT(sa.pay_date,7))，准备在case 中，做除法，然后和avg_amount比较，
-- 但是的25000/3 和 8333.33 比就是不正确的，所以此处使用了 在 子查询中，直接算出除法之后的值
SELECT pay_month ,department_id , avg_amount ,CASE WHEN sum_amount < avg_amount THEN 'lower'
                                                   WHEN sum_amount > avg_amount THEN 'higher'
                                                   ELSE 'same' END AS comparison
FROM
    (
        SELECT DISTINCT LEFT(sa.pay_date,7) AS pay_month , em.department_id ,
            AVG(sa.amount) OVER(PARTITION BY LEFT(sa.pay_date,7)) avg_amount ,
            (SUM(sa.amount) OVER(PARTITION BY em.department_id,LEFT(sa.pay_date,7)))/(COUNT(*) OVER(PARTITION BY em.department_id,LEFT(sa.pay_date,7))) AS sum_amount
-- 上面的一句，也可以替换成 AVG(sa.amount) OVER(PARTITION BY em.department_id,LEFT(sa.pay_date,7)) AS sum_amount   。。。avg开窗当然也可以支持多个partition by啊
        FROM salary_615 sa LEFT JOIN employee_615 em ON sa.employee_id = em.employee_id ORDER BY sa.pay_date DESC
    ) p;


-- leet code 618 学生地理信息报告 ******
-- 根据原始数据，展示每个地区都有哪些学生
-- 根据题目的评论分析对应做法
-- 最后输出的行 分别是 亚洲、欧洲和美洲，所以肯定需要用到行转列
-- 但问题时如何让name变成多行呢，这是个问题。这里使用 row_number()函数，按 地区 分组 记录每行的行号。
-- 根据这个子查询，通过行号进行分组，在进行行专列的操作
SELECT
    MAX(IF(continent='America',NAME,NULL)) America,
    MAX(IF(continent='Asia',NAME,NULL)) Asia,
    MAX(IF(continent='Europe',NAME,NULL)) Europe
FROM
    (
        SELECT * , ROW_NUMBER() OVER(PARTITION BY continent ORDER BY NAME) AS rk FROM student_618
    ) p GROUP BY rk;

-- leetcode 1045
-- 找出 customer表中 购买了 product 表中所有产品的客户id
SELECT p.customer_id
FROM
    (SELECT COUNT(1) AS cnt FROM product_1045) q
   , (
    SELECT customer_id , COUNT(1) AS cnt FROM (SELECT DISTINCT customer_id , product_key FROM customer_1045) a GROUP BY customer_id
) p
WHERE q.cnt = p.cnt ORDER BY p.customer_id;


SELECT customer_id FROM (SELECT DISTINCT customer_id , product_key FROM customer_1045) a
GROUP BY customer_id HAVING COUNT(*) = (SELECT COUNT(1) AS cnt FROM product_1045);

--  leetcode 1076 找出报告中所有雇员最多得项目
-- 总得思路就是让 按 project_id分组之后的 count()值，等于最大的分组的count(),
-- 第一中写法就是用了多个子查询，然后再跟着where条件相等。
SELECT project_id FROM
                      (SELECT project_id, COUNT(1) AS cnt FROM  project_1076 GROUP BY project_id ) t
        ,
                      (SELECT MAX(p.cnt) maxcnt
                       FROM
                           (
                               SELECT  COUNT(1) AS cnt FROM  project_1076 GROUP BY project_id
                           ) p ) q
WHERE t.cnt = q.maxcnt;


SELECT project_id FROM  project_1076 GROUP BY project_id
HAVING COUNT(*) = (SELECT  COUNT(1) AS cnt FROM  project_1076 GROUP BY project_id ORDER BY cnt DESC LIMIT 1 );

-- leetcode 1082
-- 查询总销售额最高的销售者，如果有并列的，都展示出来
SELECT DISTINCT t.seller_id FROM
    (SELECT  seller_id, SUM(price) OVER(PARTITION BY seller_id) sum_pri FROM sales_1082 ) t
                               ,(
        SELECT  SUM(price) sum_pri FROM sales_1082 GROUP BY seller_id ORDER BY sum_pri DESC LIMIT 1
    ) p WHERE t.sum_pri = p.sum_pri;
-- group by之后的having，不仅可以使用 count，还可以使用sum以及其他的聚合函数
SELECT  seller_id FROM sales_1082 GROUP BY seller_id HAVING SUM(price) =
                                                            (
                                                                SELECT  SUM(price) sum_pri FROM sales_1082 GROUP BY seller_id ORDER BY sum_pri DESC LIMIT 1
    );

-- leet code 1083
-- 查询购买了s8 手机却没有购买iPhone的买家
-- 自己写的这个查询会比较耗时
SELECT buyer_id FROM sales_1082  WHERE buyer_id IN
                                       (SELECT buyer_id FROM sales_1082 s LEFT JOIN product_1082 p ON s.product_id = p.product_id
                                        WHERE p.product_name='S8') AND buyer_id  NOT IN (SELECT buyer_id FROM sales_1082 s LEFT JOIN product_1082 p ON s.product_id = p.product_id
                                                                                         WHERE p.product_name='iPhone') ;

-- 使用having 求 name=s8和name=iPhone的和，需要s8的和大于0 ，iPhone的和=0(不包含s8)
SELECT s.buyer_id , SUM(pro.product_name = 's8') ,SUM(pro.product_name = 'iPhone')
FROM sales_1082 s LEFT JOIN product_1082 pro ON s.product_id = pro.product_id
GROUP BY s.buyer_id ;
-- HAVING SUM(pro.product_name = 's8') > 0 AND SUM(pro.product_name = 'iPhone') = 0

-- leetcode 1097 游戏玩法 分析 V
-- 几个设定的条件
-- 玩家的 安装日期 定义为该玩家的第一个登录日。
-- 玩家的 第一天留存率 定义为：假定安装日期为 X 的玩家的数量为 N ，
-- 其中在 X 之后的一天重新登录的玩家数量为 M ，M/N 就是第一天留存率，四舍五入到小数点后两位。

-- 解题思路: 首先需要确定每个玩家第一个登陆日 ，通过下面的语句
-- SELECT player_id , MIN(event_date) AS event_date FROM activity_1097 GROUP BY player_id
-- 然后要 找出登陆日之后第二天，仍然在登陆的玩家，同时此处有个地方需要注意， 玩家A第一天登陆了，第二天也登陆了，但第二天B玩家也登陆了并且是第一次登陆
-- 那么这个时候，留存率就是1，不能把第二天第一次登陆的B也算进留存率l里面
SELECT a.event_date AS install_dt,COUNT(1)  AS installs,
       ROUND(
               IFNULL(
                           (
                               SELECT b.cnt FROM
                                   (
-- 该临时表表示根据首次登陆的玩家，查询出第二天依然再登陆的相同玩家(和第一天登陆的相同)，此处的event_date就是首次登陆的时间，为了和时间做关联
                                       (SELECT a.event_date,COUNT(1) AS cnt FROM activity_1097 p ,
                                                                                 (SELECT player_id , MIN(event_date) AS event_date FROM activity_1097 GROUP BY player_id) a
                                        WHERE p.player_id = a.player_id AND p.event_date  = DATE_ADD(a.event_date,INTERVAL 1 DAY) GROUP BY a.event_date
                                       )
                                   ) b WHERE b.event_date = a.event_date)/COUNT(1)
                   ,0.00)
           ,2)
                    AS Day1_retention
FROM (
-- 玩家的首次登陆日
         SELECT player_id , MIN(event_date) AS event_date FROM activity_1097 GROUP BY player_id
     ) a GROUP BY a.event_date;

-- 另一种写法，更简洁，直接使用sum()计算总数，sum里面是一个in条件直接找出第二天登陆的用户数量，同时in的范围也是第一天用户的id
SELECT a.event_date AS install_dt,COUNT(1)  AS installs,
       ROUND(SUM(DATE_ADD(a.event_date,INTERVAL 1 DAY) IN (SELECT event_date FROM activity_1097 p WHERE p.player_id = a.player_id))/COUNT(*),2)
                    AS Day1_retention
FROM
    ( SELECT player_id , MIN(event_date) AS event_date FROM activity_1097 GROUP BY player_id) a
GROUP BY a.event_date;

-- leetcode 1098 筛选出过去一年中订单总量少于10本的书籍
-- 注意 不考虑上架(available_from) 距今 不满一个月的书籍，并且假设今天是2019-06-23
SELECT book_id , NAME
FROM (
         SELECT a.book_id ,a.name,IFNULL(b.quantity,0) AS quantity FROM
             (
                 SELECT book_id , NAME FROM  books_1098 WHERE available_from < DATE_ADD('2019-06-23',INTERVAL -30 DAY)
             ) a LEFT JOIN
             (
                 SELECT book_id,quantity FROM orders_1098 WHERE dispatch_date > DATE_ADD('2019-06-23',INTERVAL -365 DAY)
             ) b ON a.book_id = b.book_id
     ) p GROUP BY book_id,NAME HAVING SUM(quantity) <10;


-- 另一种写法，使用left join方式
-- 注意 此处几种不同的使用方式，结果不同，下面这种写法是能出来正确结果的
-- 大致可以总结为 要展示的数据 放在左表位置，右表的条件要跟在on后面的and，而不是作为where的条件
SELECT o.*,b.name FROM books_1098 b  LEFT JOIN orders_1098 o  ON o.book_id = b.book_id AND o.dispatch_date > DATE_ADD('2019-06-23',INTERVAL -365 DAY)
WHERE b.available_from < DATE_ADD('2019-06-23',INTERVAL -30 DAY) ;
-- 上面sql的几种变种，第一种，orders表在前 book表在后，这样的话 会导致以 order表为主，过滤掉时间之后，会少相关的name数据，
-- 但其实这个数据也是要的，只不过数量是null或者再orders表不存在而已
SELECT o.*,b.name FROM   orders_1098 o LEFT JOIN books_1098 b  ON o.book_id = b.book_id AND o.dispatch_date > DATE_ADD('2019-06-23',INTERVAL -365 DAY)
WHERE b.available_from < DATE_ADD('2019-06-23',INTERVAL -30 DAY) ;
-- 变种2 将 订单时间的条件放在where中，也会出现结果不正常的情况，这个是为什么呢？？
SELECT o.*,b.name FROM books_1098 b  LEFT JOIN orders_1098 o  ON o.book_id = b.book_id
WHERE b.available_from < DATE_ADD('2019-06-23',INTERVAL -30 DAY) AND o.dispatch_date > DATE_ADD('2019-06-23',INTERVAL -365 DAY);

-- leetcode1112 每位学生的最高成绩
-- 编写一个 SQL 查询，查询每位学生获得的最高成绩和它所对应的科目，若科目成绩并列，取 course_id 最小的一门。查询结果需按 student_id 增序进行排序
SELECT student_id,course_id,grade FROM
    (
        SELECT student_id,course_id,grade,RANK() OVER(PARTITION BY student_id ORDER BY grade DESC,course_id ASC) rk FROM enrollments_1112
    ) p WHERE rk = 1;

-- leetcode 1127 用户购买平台 *****
-- 写一段 SQL 来查找每天 仅 使用手机端用户、仅 使用桌面端用户和 同时 使用桌面端和手机端的用户人数和总支出金额。
-- platform 包括 desktop , mobile 两个平台
-- 在 2019-07-01, 用户1 同时 使用桌面端和手机端购买, 用户2 仅 使用了手机端购买，而用户3 仅 使用了桌面端购买。
-- 在 2019-07-02, 用户2 仅 使用了手机端购买, 用户3 仅 使用了桌面端购买，且没有用户 同时 使用桌面端和手机端购买。

-- 先通过聚合的开窗函数，找出每个用户在每天登陆的平台数量、按天的amount总数
-- 然后对这个查询结果求出每个用户、每个日期、平台(mobile\desktop\both)、amount总数，在对这个结果按平台、日期求amount和，人数和
-- 但这样就会出一个问题，会出现有的天有 三个平台结果，有的天 只有两个或一个平台的结果。如何将每天的三个平台都展示出来是一个问题
-- 最终，采用了题目评论中的方式 使用 日期，三个平台相互 union 形成左表，然后和上面的结果进行 left join
-- 结论: 添加表中不存在的列并设定列的固定值的公式为
-- select id, 'value' extra from table （value为添加的固定值 extra为列名）

SELECT DISTINCT a.spend_date,a.platform ,
                IFNULL(SUM(t.sum_amount) OVER(PARTITION BY t.platform,t.spend_date),0) AS sum_amount,
                COUNT(t.user_id) OVER(PARTITION BY t.platform,t.spend_date) AS total_users
FROM
    (
-- 每个日期都对应一个desktop\mobile\both,作为左表
        SELECT DISTINCT spend_date, "desktop" AS platform FROM Spending_1127
        UNION
        SELECT DISTINCT spend_date, "mobile" AS platform FROM Spending_1127
        UNION
        SELECT DISTINCT spend_date, "both" AS platform FROM Spending_1127
    ) a
        LEFT JOIN
    (
        SELECT DISTINCT user_id,spend_date, IF(cnt_platform=2,'both',platform) AS platform,sum_amount
        FROM
            (
-- 先通过聚合的开窗函数，找出每个用户在每天登陆的平台数量、按天的amount总数
                SELECT user_id , spend_date , amount, platform ,
                       COUNT(platform) OVER(PARTITION BY spend_date,user_id) AS cnt_platform ,
                       SUM(amount) OVER(PARTITION BY spend_date,user_id) AS sum_amount
                FROM spending_1127
            ) p
    ) t
    ON
                a.platform = t.platform AND a.spend_date = t.spend_date ORDER BY a.spend_date;

-- leetcode 1132
-- 目前结果是不对的，还没AC
SELECT ROUND(AVG(su/cnt)*100,2) AS average_daily_percent
FROM
    (
        SELECT action_date,SUM(rem_cnt) AS su,cnt
        FROM
            (
                SELECT a.post_id,action_date,COUNT(*) OVER(PARTITION BY action_date) cnt ,IF(b.remove_date,1,0) rem_cnt
                FROM actions_1132 a LEFT JOIN removals_1132 b ON a.post_id = b.post_id WHERE extra = 'spam'
            ) p
        GROUP BY action_date
    ) t;

-- leetcode 1141
-- 最近30天活跃的用户
SELECT DISTINCT activity_date AS `day`,COUNT(1) OVER(PARTITION BY activity_date) AS active_users
FROM (
         SELECT activity_date , user_id FROM activity_1141 WHERE activity_date >= '2019-06-28' AND activity_date <= '2019-07-27'
         GROUP BY user_id,activity_date HAVING COUNT(DISTINCT activity_type) >= 1
     ) p;

-- leetcode 1142
-- 编写SQL查询以查找截至2019年7月27日（含）的30天内每个用户的平均会话数
SELECT ROUND(IFNULL(SUM(session_cnt)/COUNT(DISTINCT user_id),0.00),2) AS average_sessions_per_user  FROM
    (
        SELECT user_id , COUNT(1) OVER(PARTITION BY session_id) AS session_cnt FROM activity_1141 WHERE activity_date >= '2019-06-28' AND activity_date <= '2019-07-27'
        GROUP BY user_id,session_id
    ) p;


-- leetcode 1159
--  查询确定每一个用户按日期顺序卖出的第二件商品的品牌是否是他们最喜爱的品牌。如果一个用户卖出少于两件商品，查询的结果是 no 。
-- 题目保证没有一个用户在一天中卖出超过一件商品

SELECT u.user_id seller_id , IFNULL(eq,'no') 2nd_item_fav_brand FROM users_1159 u LEFT JOIN
                                                                     (
-- 内存子查询 通过联合查询 查出 用户喜欢的品牌、每个卖出的品牌和喜欢的品牌是否相同，按用户分组时间排名，计算每个卖家卖出的数据量总数
                                                                         SELECT user_id,IF(item_brand=u.favorite_brand,'yes','no') eq,
                                                                                RANK() OVER(PARTITION BY seller_id ORDER BY order_date ASC) date_order
                                                                         FROM  users_1159 u LEFT JOIN orders_1159 o ON o.seller_id = u.user_id  LEFT JOIN items_1159 i ON o.item_id = i.item_id ) p
                                                                     ON u.user_id = p.user_id AND p.date_order = 2;


-- leetcode 1164 查找在 2019-08-16 时全部产品的价格，假设所有产品在修改前的价格都是 10。
-- 分析题目和样例，题目是要查找出来2019-08-16 这一天的价格。如果当天确实更改了价格，则使用当天的价格
-- 如果当天没有更改，但之前更改过，则用最近的更改日期的价格；如果这一天之前都没有改过，则使用默认价格 10
-- left join 右侧的查询 就是找出 小于等于 2019-08-16 这天的所有数据，并按照日期排序，直接取排序后的第一条数据，即为当天的日期
-- 通过左连接，找出 不存在右侧的数据(16号之后没有更改过)，默认为10 。left join 右侧的条件要放在and后面，否则结果中不会出现为空的数据
SELECT t.product_id,IFNULL(new_price,10) price  FROM
    (SELECT DISTINCT product_id FROM products_1164) t
        LEFT JOIN
    (
        SELECT product_id , new_price , change_date ,
               RANK() OVER(PARTITION BY product_id ORDER BY change_date DESC) date_order
        FROM products_1164 WHERE change_date <= '2019-08-16'
    ) p ON t.product_id = p.product_id
        AND date_order = 1;


-- leetcode 1193
-- 编写一个 sql 查询来查找每个月和每个国家/地区的事务数及其总金额、已批准的事务数及其总金额
-- 题目不难，主要是再计算 approved_total_amount的时候，使用了sum函数，并且在sum函数中，使用了if条件(自己写的时候是使用了一遍子查询)
-- 按年月分组
SELECT LEFT(trans_date,7) `month` ,country ,COUNT(1) AS trans_count ,
    SUM(state='approved') approved_count,SUM(amount) trans_total_amount ,
-- 使用sum if进行求和
    SUM(IF(state='approved',amount,0)) ov ,
-- 使用子查询的方式求和，效率低
    (SELECT SUM(amount) FROM transactions_1193 WHERE LEFT(trans_date,7) = `month` AND country = t.country AND state = 'approved') AS approved_total_amount
FROM transactions_1193 t
GROUP BY LEFT(trans_date,7),country;


-- leetcode 1194
-- 编写一个sql查询每组中获胜者；要求:每组的获胜者是在组内累积得分最高的选手。如果平局，player_id 最小 的选手获胜
-- 每次比赛都有两个用户，需要求出用户在所有比赛中的得分，找出组内得分最高的用户，
-- 此处使用union all 的形式把 first_player,first_score和second_player,second_score 由四列变成两列，
-- 然后再按player_id求和，结合分组再求和找出得分最高的用户
SELECT group_id , MIN(player)  player_id
FROM
    (
        SELECT
            p.group_id , player , score ,  RANK() OVER(PARTITION BY p.group_id ORDER BY score DESC) `rank`
        FROM
            (
                SELECT
                    player , SUM(sum_score) score
                FROM
                    (
                        SELECT first_player player ,
                               SUM(first_score)  sum_score
                        FROM matches_1194 GROUP BY first_player
                        UNION ALL
                        SELECT second_player player ,
                               SUM(second_score)  sum_score
                        FROM matches_1194 GROUP BY second_player
                    ) m GROUP BY player
            ) t LEFT JOIN players_1194 p ON t.player = p.player_id
    ) q WHERE `rank` = 1 GROUP BY group_id;

-- 下面这种写法不符合题意，求的是每场比赛得分最高的
-- 题目要得是每组每个用户累计得分，这个sql表达得是每场比赛得最高份
-- 此处使用了 least函数、greatest函数
SELECT group_id , player player_id
FROM
    (
        SELECT p.group_id , t.player , t.score , RANK() OVER(PARTITION BY group_id ORDER BY score DESC,player ASC) `rank`
        FROM
            (
                SELECT IF(first_score>second_score,first_player,(IF(first_score<second_score,second_player,LEAST(first_player,second_player)))) AS player,
                       GREATEST(first_score,second_score) AS score
                FROM matches_1194
            ) t LEFT JOIN players_1194 p ON p.player_id = t.player
    ) q WHERE `rank` = 1;
