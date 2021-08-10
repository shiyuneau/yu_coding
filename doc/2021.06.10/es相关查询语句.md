## es 相关查询语句
----
> 主要记录工作中遇到的 es 原生查询语句，方便后期使用
> 

#### 查询
1. 模糊查询
	
	> multi_match 中type 类型可查看 https://www.6aiq.com/article/1552148885834
   
   ```java
   {
    // multi_match 能在多个字段上反复执行相同查询，目前使用对 单字段或多字段的模糊查询上，类似于全文搜索
    "from":0, // 从第多少条开始查询
    "size":10,
    "track_total_hits":true, //显示查询的总数量
    "query": {
        "bool": {
            "must": [
                {
                    "multi_match": {
                        "query": "吴承恩", //查询条件
                        "fields": [ // 查询字段
                            "作者^1.0" // 字段*数值，可以对字段值进行放大
                        ],
                        "type": "best_fields", // 类型，包括 most_fields\best_firlds\cross_fields,
                        "operator": "OR",
                        "analyzer": "ik_smart", // 分词器
                        "slop": 0,
                        "prefix_length": 0,
                        "max_expansions": 50,
                        "zero_terms_query": "NONE",
                        "auto_generate_synonyms_phrase_query": true,
                        "fuzzy_transpositions": true,
                        "boost": 1.0,
                        "minimum_should_match": "-40%" // 最小应该匹配得词 得百分比。如分词结果是5，当为20%时，最少匹配2个(向下取整)，当为-30%时，最少匹配5-5*0.3=4 个
                    }
                }
            ],
            "adjust_pure_negative": true,
            "boost": 1.0
        }
    },
    "sort": [ //排序
        {
            "_score": {
                "order": "desc"
            }
        }
    ],
    "highlight": { //字段高亮
        "pre_tags": [
            "<font color='ff6666'>"
        ],
        "post_tags": [
            "</font>"
	     ],
	  "fields": {
	         "*": {}
	     }
	 }
	}
	```
	---
	```java
   {
    // 全文匹配，根据查询条件进行全文的模糊匹配
        "query": {
           "query_string" : {
               "query":"吴承恩",
               "tie_breaker":0.1,
               "analyze_wildcard":false
           }
       }
   }
   ```
---
2. 字段去重
	```java
	{
       // 该方式通过聚合的方式，字段去重的同时，计算出每个值得数量，同时显示几条相关数据。默认按照每个值得数量进行排序返回
      "aggs": {
        "target_oid": { // 输出得聚合结果得字段名称
          "terms": { // 聚合条件
            "field": "作者.keyword", // 根据哪个字段进行聚合
            "size": 2 // 聚合后展示的结果数量
          },//只要以上部分就可以查询出来聚合后的结果，下面的内容会查询出相关的数据
            "aggs": {
            "rated": {
              "top_hits": {
                "sort": [{ // 相关的数据的排序方式
                  "出版日期.keyword": {"order": "desc"}
                }], 
                "size": 1 //查询出相关数据的个数
              }
            }
            // 更改 排序顺序
                "genders" : {
               "terms" : {
                   "field" : "gender",
	                "order" : { "_count" : "desc" }
	            }
	        }
	         //
	       }
	     }
	   }, 
	   "size": 0,
	   "from": 0
	 }
	```
	---
	也可以使用下面这种方式，简化很多，性能也好很多,而且这种返回得结果不会根据总数进行排序
	```java
	{
        "collapse":{
        	"field":"作者.keyword"
        },
        "size":5, // 返回得个数
        "from": 0
    }

	```

