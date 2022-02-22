-- 创建数据库
create database myDatabase;
create database myDatabase2 charset gbk;

-- 显示所有数据库
show databases;

-- 查看以my开头的数据库
show databases like 'my%';

-- 查看数据库创建语句
show create database mydatabase;

-- 选择数据库
use mydatabase;

-- 修改数据库字符集
alter database myDatabase2 charset = utf8;

-- 删除数据库
drop database mydatabase2；

-- 创建数据表1(进入数据库再创建)
create table class(
-- 字段名 字段类型 [字段属性],字段名 字段类型 [字段属性]...
name varchar(10),
sex varchar(1)
);

-- 创建数据表2(进入数据库再创建)
create table mydatabase.teacher(
-- 字段名 字段类型 [字段属性],字段名 字段类型 [字段属性]...
name varchar(10),
sex varchar(1)
);

-- 使用表选项
create table mydatabase.student(
-- 字段名 字段类型 [字段属性],字段名 字段类型 [字段属性]...
name varchar(10),
sex varchar(1)
)charset gbk;

-- 复制表（只能复制结构，数据不能复制）
create table student like mydatabase.student;

-- 查看所有表
show tables;

-- 查看表
show tables like 's%';

-- 显示表结构
Describe student;
Desc teacher;
show columns from class;

-- 查看表创建语句
show create table student;

-- 修改表选项
alter table class charset=gbk;

-- 修改表名
rename table class to my_class;

-- 增加字段
alter table my_class add age int after name;

-- 修改字段名
alter table my_class change age hobbies varchar(10);

-- 修改字段类型
alter table my_class modify hobbies varchar(25);

-- 删除字段
alter table my_class drop likes;

-- 删除表
drop table student,teacher;

-- 插入数据
insert into my_class (hobbies) values ('sports');

-- 插入数据
insert into my_class (sex,name) values ('male','luky');

-- 插入所有字段数据
insert into my_class values ('jack','basketball','male');

-- 查询所有数据
select * from my_class;

-- 查看指定字段数据
select name,sex from my_class;

-- 条件查询
select name from my_class where hobbies = 'swimm';
select * from my_class where hobbies = 'swimm';

-- 删除数据
delete from my_class where hobbies = 'sports';

-- 更新数据
update my_class set sex = 'female' where name = 'luky';

-- 插入中文
set names gbk;-- 这里对应mysql.exe运行环境使用的编码，即cmd里使用gbk;
insert into my_class values ('Casy','swimm','female');

-- 数据类型-整形
-- 无符号
alter table my_class add age int unsigned after name;
-- 可显示指定长度，不够用零补充(使用zerofill则自动为无符号，负数不能使用zerofill)
-- 注意“int(5)”只是指定显示长度，age的范围还是4字节的int
alter table my_class add age int(5) zerofill after name;

-- 数据类型-浮点型
-- （float）个人理解：第九位要向第八位进位，但第九位变得不稳定，甚至出现负数
-- float 7位精度有效,double为15有效精度，精度丢失则四舍五入
-- 10位有效数字，小数2位，即整数8位，小数2位（注意：插入数据整数部分不能超出指定整数部分）
alter table my_class add scrore float(10,2) after name;
-- 可采用科学计数法
update my_class set scrore = 10e5 where name = 'jack';

-- 数据类型-定点型（能保证精度，小数部分不能）
-- decimal(M,D)M总长度，最大为35，D小数，最大30

-- 时间日期类型
create table my_date(
date1 date,
date2 time,
date3 datetime,
date4 timestamp,
date5 year
)charset utf8;

create table my_date(
date1 date,
date2 time,
date3 datetime,
date4 timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
date5 year
)charset utf8;

insert into my_date values(
'1900-01-01','12:12:12','1900-01-01 12:12:12','1999-01-01 12:12:12',2018
);

-- 列属性 --
-- 默认值
create table my_default(
name varchar(10) not null,
age int default 18
);

insert into my_default(name) values('jack');
insert into my_default values('mack',default);

-- 列描述
create table my_comment(
name varchar(10) not null comment'用户名不能为空',
age int default 18
);

-- 主键 --
create table my_primaryKey2(
userName varchar(10) primary key
)charset utf8;

create table my_primaryKey(
userName varchar(10),
primary key(userName)
)charset utf8;

create table my_pri3(
userName varchar(10),
love varchar(10)
)charset utf8;

create table my_pri4(
userName varchar(10),
love varchar(10),
primary key(userName,love)
)charset utf8;

create table my_pri4(
userName varchar(10) primary key,
love varchar(10)primary key
)charset utf8;

-- 删除主键
alter table my_primarykey drop primary key;

-- 自动增长 --
create table my_increase(
id int primary key auto_increment,
name varchar(10) not null comment '用户名',
pass varchar(10) not null comment '密码'
)charset utf8;


insert into my_increase values(null,'Mack','123456');

-- 修改自增长
alter table my_increase auto_increment=10;

-- 删除自增长
alter table my_increase modify id int;

-- 查看自增长变量
show variables like 'auto_inrement%';

-- 唯一键 --
create table my_unique(
id int primary key auto_increment,
username varchar(10),
unique key(username)
);
 
-- 删除唯一键
alter table my_unique drop index username;

-- 增加唯一键
alter table my_unique add unique key(username);

create table my_unique2(
id int primary key auto_increment,
username varchar(10),
age int,
unique key(username,age)
);

create table my_unique3(
id int primary key auto_increment,
username varchar(10),
age int,
unique key(username),
unique key(age)
);

-- 插入多条数据 --
insert into my_pri3 (userName,love) values ('Lucky','yes'),('Jack','yes');

-- 主键冲突 --
-- 主键冲突更新
insert into my_pri3 values ('Lucky','no') on duplicate key update love = 'no';

-- 主键冲突替换
replace into my_pri3 values ('Lucky','yes');


-- 蠕虫复制 --
create table my_copy(
name varchar(10)not null
)charset utf8;

insert into my_copy values ('Jacd'),('Mack');

insert into my_copy(name) select name from my_copy;

-- 高级查询 --
-- 去掉重复
select distinct * from my_copy;

-- 别名
select name as name1,name as name2 from my_copy;

-- 多表查询
select * from my_copy，my_increase;

-- 动态数据
select * from (select name,pass from my_increase) as increase;

-- 分组
select * from my_class group by class_id;
--使用聚合函数
select class_id,count(*),max(age),min(scrore),avg(scrore) from my_class group by class_id;
select class_id,group_concat(name),count(*),max(age),min(scrore),avg(scrore) from my_class group by class_id;

-- 多分组
select class_id,scrore,group_concat(name),count(*) from my_class group by class_id,scrore;
-- 分组排序(asc升序，desc降序)
select class_id,scrore,group_concat(name),count(*) from my_class group by class_id desc,scrore asc;

-- 回溯统计
select class_id,count(*),group_concat(name) from my_class group by class_id desc with rollup;
select class_id,scrore,group_concat(name),count(*) from my_class group by class_id desc,scrore asc with rollup;

-- having
select class_id,count(*) as number,group_concat(name) from my_class group by class_id having number>=2;
select class_id,count(*),group_concat(name) from my_class group by class_id having count(*)>=2;

-- order by(排序)
select * from my_class order by scrore desc;
select * from my_class order by scrore desc,class_id desc;

-- limit --
select * from my_class limit 3;
-- 分页
select * from my_class limit 0,3;

-- 算数运算 --
select int_1+int_2,int_4/3 from my_numbers;

-- 比较运算 --
select '1' <=> 1,0.02 <=> 0;
select * from my_class where class_id between 2 and 3;

-- 逻辑运算 --(and,or,not)
select * from my_class where class_id >=2 and class_id <=3;
select * from my_class where class_id >=2 and class_id <=3;

-- in 运算符 --
select * from my_class where class_id in ('1','3');

-- is 运算符 --
select * from my_class where age is not null;

-- like --

select * from my_class where hobbies like 's%';
select * from my_class where name like 'M____';

-- 联合查询 --
-- 若要使用order by 必须使用括号和limit
(select * from my_class where sex = 'male'order by class_id asc limit 8)
union
(select * from my_class where sex = 'female' order by class_id desc limit 8);

-- 连接查询 --
-- 交叉连接
select * from my_pri3 cross join my_class;

-- 内连接
select * from my_class inner join my_test on my_class.class_id=my_test.id;
select * from my_test as m inner join my_class as t on m.id=t.class_id;

-- 外连接 --
-- 左外连接
select * from my_test as m left join my_class as t on m.id=t.class_id;
-- 右连接
select * from my_test as m right join my_class as t on m.id=t.class_id;

-- 子查询 --
-- 标量查询（Mack 所在班级的名字 ）
select * from my_test where id = (select class_id from my_class where name = 'Mack');
-- 列子查询 （有学生的班级）
select name from my_test where id in (select class_id from my_class);
-- 行子查询 (分数最小且年龄最小)
select * from my_class where (age,scrore) = (select min(age),min(scrore) from my_class);
-- 表子查询（每个班成绩最差的）
select * from (select * from my_class order by scrore asc limit 10) as tmp group by class_id;
-- exists (有学生的班级)
select * from my_test as c where exists (select class_id from my_class as s where s.class_id = c.id);

-- 关键字 --
-- in
select * from my_test where id in (select class_id from my_class);
-- any
select * from my_test where id =any (select class_id from my_class);
select * from my_test where id <>any (select class_id from my_class);
-- some 同any
-- all
select * from my_test where id =all (select class_id from my_class);
select * from my_test where id <>all (select class_id from my_class);

set global sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

set session sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

create table my_numbers(
int_1 int,
int_2 int,
int_3 int,
int_4 int
)charset utf8;
insert into my_numbers values(12,-45,0,44);

create table secret(
id int auto_increment,
type varchar(10) not null comment'账号类型',
account varchar(20) comment'账号',
password varchar(20) comment'密码',
phonenum varchar(20) comment'绑定手机号',
remark text comment'备注',
primary key(id),
unique key(type,account)
)charset utf8;

create table thread(
name varchar(10),
age tinyint,
hobby varchar(10)
)charset utf8;

package login;

import CommonConstant.CommonConstant;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.HttpUserModel;
import model.UserModel;
import register.Register;
import utils.DBCPUtils;

/**
 *
 * @author Acer
 */
public class Login extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
    {
        doPost(request,response);
        
        response.setContentType("text/plain; charset=utf-8");
	response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
	String string = "Have a wonderful day";
	out.print(string);
	out.close();

    }

    public void doPost(HttpServletRequest request, HttpServletResponse response){
        PrintWriter out = null;
        Connection connection = null;
        Statement statement = null;
        ResultSet result = null;
        
        HttpUserModel httpUserModel = new HttpUserModel();
        List<UserModel> users = new ArrayList();
        UserModel userModel = new UserModel();
        
        try {
            response.setContentType("text/javascript; charset=utf-8");
            response.setCharacterEncoding("UTF-8");
            out = response.getWriter();
            String account = request.getParameter("account");
            String pass = request.getParameter("password");
            
            connection = DBCPUtils.getConnection();
            statement = connection.createStatement();
            String querySql = "select * from " + CommonConstant.TABLE_USER + " where account = '" + account + "'";
            result = statement.executeQuery(querySql);
                
            if(result.next()){
                String password = result.getString("password");
                if(password != null && password.equals(pass)){
                    userModel.setAccount(result.getString("account"));
                    userModel.setPassword(password);
                    userModel.setNickname(result.getString("nickname"));
                    userModel.setLifeMotto(result.getString("lifemotto"));
                    userModel.setImageUrl(result.getString("imageurl"));
                    userModel.setRemark(result.getString("remark"));
                    users.add(userModel);
                    httpUserModel.setContent(users);
                    httpUserModel.setResult("success");
                }else{
                    httpUserModel.setResult("fail");
                    httpUserModel.setMessage("密码错误！");
                }
            }else{
                httpUserModel.setResult("fail");
                httpUserModel.setMessage("账号信息不存在！");
            }
            Gson gson = new Gson();
            String responseJson = gson.toJson(httpUserModel);
            out.print(responseJson);
        } catch (IOException ex) {
            out.print(ex.toString());
            Logger.getLogger(Register.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            out.print(ex.toString());
            Logger.getLogger(Register.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            DBCPUtils.closeAll(result, statement, connection);
            if(out != null){
                out.close();
            }
        }
    }
}