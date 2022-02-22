-- �������� --
mysqldump.exe -hlocalhost -P3306 -uroot -p mydatabase > d:MySQL/BACK-UP/mydatabase.sql
-- �����
mysqldump.exe -hlocalhost -P3306 -uroot -p mydatabase my_class my_test my_pri3 > d:MySQL/BACK-UP/my_class.sql

-- ���ݻ�ԭ --
-- ����1���ⲿ
mysql.exe -hlocalhost -P3306 -uroot -p mydb < d:MySQL/BACK-UP/mydatabase.sql
-- ����2���Ƚ������ݿ�
source d:MySQL/BACK-UP/my_class.sql;

-- �û�Ȩ�� --
select * from mysql.user\G;
desc mysql.user\G

-- �����û�
create user 'user1'@'%' identified by '123456';

-- �����û�(��������)
create user user2;

-- ɾ���û�
drop user 'user1'@'%';
drop user user2;

-- �޸�����
set password for 'user1'@'%' = '654321';
set password for 'user1'@'%' = password('123'); (���ܰ汾����˷���ʧ��)
update mysql.user set password = '654321' where user = 'user1' and host = '%';(ʧ��) 
update mysql.user set password = password('654321') where user = 'user1' and host = '%';(ʧ��)
alter user 'user1'@'%' identified by '123456';(�ɹ�)

-- ����Ȩ��
grant select on mydatabase.my_class to 'user1'@'%';

-- ȡ��Ȩ��(����)
revoke all privileges on mydatabase.my_class from 'user1'@'%';

-- ˢ��Ȩ��
flush privileges;

-- root ��������
-- 1��ֹͣ����
net stop mysql
-- 2������������������Ȩ��(��ʱ���������½���ǳ�Σ��)
mysqld.exe --shared-memory --skip-grant-tables
-- 3,ˢ��Ȩ��
flush privileges;
-- 3������mysql�޸����� 
ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';
alter user 'root'@'localhost' identified by 'wonderful123456';
-- 4,�رս�������

-- ������� --
-- ����1
create table my_foreign(
id int primary key auto_increment,
name varchar(10) not null,
class_id int,
foreign key(class_id) references my_test(id)
)charset gbk;
-- ����2
alter table my_pri3 add constraint `pri3_class_idgfk_1` foreign key(class_id) references my_test(id);

-- ɾ�����
alter table my_pri3 drop foreign key `pri3_class_idgfk_1`;

-- ��ӱ���������ı���������
insert into my_pri3 values ('Green','yes',4);
insert into my_pri3 values ('Lrue','no',5);(������Ϊ����û��id 5);
delete from my_test where id = 2;(ʧ�ܣ��޷�ɾ���ӱ������ͬ���ֵ������)

-- ���Լ��
alter table my_student add constraint `my_student_foreign_key` foreign key(class_id) references my_test(id) on update cascade on delete set null;
update my_test set id = 5 where id = 1;(��ʱmy_studentԭ��class_id Ϊ1��Ҳ��Ϊ5)
delete from my_test where id = 5;(��ʱmy_studentԭ��class_id Ϊ5�ı�Ϊnull)

-- ������ͼ
create view student_class_v as
select s.*,c.name as classname from my_class as s left join
my_test as c on s.class_id = c.id;


-- �鿴�Զ�������Ʊ���
show variables like 'autocommit';
-- �ر��Զ�����
set autocommit = Off;
-- �ύ����
commit;
-- ��������
rollback;

-- �ֶ����� --
-- ��������
start transaction;
-- �ύ����
commit;
-- ���ӻع���
savepoint sp1;
-- �ع�
rollback to sp1;

-- if��ʹ��
select *,if(scrore>500,'����','������') as judge from my_class;


