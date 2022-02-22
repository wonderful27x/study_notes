-- 备份整库 --
mysqldump.exe -hlocalhost -P3306 -uroot -p mydatabase > d:MySQL/BACK-UP/mydatabase.sql
-- 多表备份
mysqldump.exe -hlocalhost -P3306 -uroot -p mydatabase my_class my_test my_pri3 > d:MySQL/BACK-UP/my_class.sql

-- 数据还原 --
-- 方法1，外部
mysql.exe -hlocalhost -P3306 -uroot -p mydb < d:MySQL/BACK-UP/mydatabase.sql
-- 方法2，先进入数据库
source d:MySQL/BACK-UP/my_class.sql;

-- 用户权限 --
select * from mysql.user\G;
desc mysql.user\G

-- 创建用户
create user 'user1'@'%' identified by '123456';

-- 创建用户(不需密码)
create user user2;

-- 删除用户
drop user 'user1'@'%';
drop user user2;

-- 修改密码
set password for 'user1'@'%' = '654321';
set password for 'user1'@'%' = password('123'); (可能版本问题此方法失败)
update mysql.user set password = '654321' where user = 'user1' and host = '%';(失败) 
update mysql.user set password = password('654321') where user = 'user1' and host = '%';(失败)
alter user 'user1'@'%' identified by '123456';(成功)

-- 授予权限
grant select on mydatabase.my_class to 'user1'@'%';

-- 取消权限(所有)
revoke all privileges on mydatabase.my_class from 'user1'@'%';

-- 刷新权限
flush privileges;

-- root 密码重置
-- 1，停止服务
net stop mysql
-- 2，重启服务跳过所有权限(此时可以任意登陆，非常危险)
mysqld.exe --shared-memory --skip-grant-tables
-- 3,刷新权限
flush privileges;
-- 3，进入mysql修改密码 
ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';
alter user 'root'@'localhost' identified by 'wonderful123456';
-- 4,关闭进程重启

-- 增加外键 --
-- 方法1
create table my_foreign(
id int primary key auto_increment,
name varchar(10) not null,
class_id int,
foreign key(class_id) references my_test(id)
)charset gbk;
-- 方法2
alter table my_pri3 add constraint `pri3_class_idgfk_1` foreign key(class_id) references my_test(id);

-- 删除外键
alter table my_pri3 drop foreign key `pri3_class_idgfk_1`;

-- 向从表（含有外键的表）插入数据
insert into my_pri3 values ('Green','yes',4);
insert into my_pri3 values ('Lrue','no',5);(错误因为主表没有id 5);
delete from my_test where id = 2;(失败，无法删除从表持有相同外键值的数据)

-- 外键约束
alter table my_student add constraint `my_student_foreign_key` foreign key(class_id) references my_test(id) on update cascade on delete set null;
update my_test set id = 5 where id = 1;(这时my_student原来class_id 为1的也变为5)
delete from my_test where id = 5;(这时my_student原来class_id 为5的变为null)

-- 创建视图
create view student_class_v as
select s.*,c.name as classname from my_class as s left join
my_test as c on s.class_id = c.id;


-- 查看自动事物控制变量
show variables like 'autocommit';
-- 关闭自动事物
set autocommit = Off;
-- 提交事务
commit;
-- 撤销事物
rollback;

-- 手动事物 --
-- 开启事物
start transaction;
-- 提交事务
commit;
-- 增加回滚点
savepoint sp1;
-- 回滚
rollback to sp1;

-- if的使用
select *,if(scrore>500,'符合','不符合') as judge from my_class;


