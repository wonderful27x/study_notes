-- �������ݿ�
create database myDatabase;
create database myDatabase2 charset gbk;

-- ��ʾ�������ݿ�
show databases;

-- �鿴��my��ͷ�����ݿ�
show databases like 'my%';

-- �鿴���ݿⴴ�����
show create database mydatabase;

-- ѡ�����ݿ�
use mydatabase;

-- �޸����ݿ��ַ���
alter database myDatabase2 charset = utf8;

-- ɾ�����ݿ�
drop database mydatabase2��

-- �������ݱ�1(�������ݿ��ٴ���)
create table class(
-- �ֶ��� �ֶ����� [�ֶ�����],�ֶ��� �ֶ����� [�ֶ�����]...
name varchar(10),
sex varchar(1)
);

-- �������ݱ�2(�������ݿ��ٴ���)
create table mydatabase.teacher(
-- �ֶ��� �ֶ����� [�ֶ�����],�ֶ��� �ֶ����� [�ֶ�����]...
name varchar(10),
sex varchar(1)
);

-- ʹ�ñ�ѡ��
create table mydatabase.student(
-- �ֶ��� �ֶ����� [�ֶ�����],�ֶ��� �ֶ����� [�ֶ�����]...
name varchar(10),
sex varchar(1)
)charset gbk;

-- ���Ʊ�ֻ�ܸ��ƽṹ�����ݲ��ܸ��ƣ�
create table student like mydatabase.student;

-- �鿴���б�
show tables;

-- �鿴��
show tables like 's%';

-- ��ʾ��ṹ
Describe student;
Desc teacher;
show columns from class;

-- �鿴�������
show create table student;

-- �޸ı�ѡ��
alter table class charset=gbk;

-- �޸ı���
rename table class to my_class;

-- �����ֶ�
alter table my_class add age int after name;

-- �޸��ֶ���
alter table my_class change age hobbies varchar(10);

-- �޸��ֶ�����
alter table my_class modify hobbies varchar(25);

-- ɾ���ֶ�
alter table my_class drop likes;

-- ɾ����
drop table student,teacher;

-- ��������
insert into my_class (hobbies) values ('sports');

-- ��������
insert into my_class (sex,name) values ('male','luky');

-- ���������ֶ�����
insert into my_class values ('jack','basketball','male');

-- ��ѯ��������
select * from my_class;

-- �鿴ָ���ֶ�����
select name,sex from my_class;

-- ������ѯ
select name from my_class where hobbies = 'swimm';
select * from my_class where hobbies = 'swimm';

-- ɾ������
delete from my_class where hobbies = 'sports';

-- ��������
update my_class set sex = 'female' where name = 'luky';

-- ��������
set names gbk;-- �����Ӧmysql.exe���л���ʹ�õı��룬��cmd��ʹ��gbk;
insert into my_class values ('Casy','swimm','female');

-- ��������-����
-- �޷���
alter table my_class add age int unsigned after name;
-- ����ʾָ�����ȣ��������㲹��(ʹ��zerofill���Զ�Ϊ�޷��ţ���������ʹ��zerofill)
-- ע�⡰int(5)��ֻ��ָ����ʾ���ȣ�age�ķ�Χ����4�ֽڵ�int
alter table my_class add age int(5) zerofill after name;

-- ��������-������
-- ��float��������⣺�ھ�λҪ��ڰ�λ��λ�����ھ�λ��ò��ȶ����������ָ���
-- float 7λ������Ч,doubleΪ15��Ч���ȣ����ȶ�ʧ����������
-- 10λ��Ч���֣�С��2λ��������8λ��С��2λ��ע�⣺���������������ֲ��ܳ���ָ���������֣�
alter table my_class add scrore float(10,2) after name;
-- �ɲ��ÿ�ѧ������
update my_class set scrore = 10e5 where name = 'jack';

-- ��������-�����ͣ��ܱ�֤���ȣ�С�����ֲ��ܣ�
-- decimal(M,D)M�ܳ��ȣ����Ϊ35��DС�������30

-- ʱ����������
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

-- ������ --
-- Ĭ��ֵ
create table my_default(
name varchar(10) not null,
age int default 18
);

insert into my_default(name) values('jack');
insert into my_default values('mack',default);

-- ������
create table my_comment(
name varchar(10) not null comment'�û�������Ϊ��',
age int default 18
);

-- ���� --
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

-- ɾ������
alter table my_primarykey drop primary key;

-- �Զ����� --
create table my_increase(
id int primary key auto_increment,
name varchar(10) not null comment '�û���',
pass varchar(10) not null comment '����'
)charset utf8;


insert into my_increase values(null,'Mack','123456');

-- �޸�������
alter table my_increase auto_increment=10;

-- ɾ��������
alter table my_increase modify id int;

-- �鿴����������
show variables like 'auto_inrement%';

-- Ψһ�� --
create table my_unique(
id int primary key auto_increment,
username varchar(10),
unique key(username)
);
 
-- ɾ��Ψһ��
alter table my_unique drop index username;

-- ����Ψһ��
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

-- ����������� --
insert into my_pri3 (userName,love) values ('Lucky','yes'),('Jack','yes');

-- ������ͻ --
-- ������ͻ����
insert into my_pri3 values ('Lucky','no') on duplicate key update love = 'no';

-- ������ͻ�滻
replace into my_pri3 values ('Lucky','yes');


-- ��渴�� --
create table my_copy(
name varchar(10)not null
)charset utf8;

insert into my_copy values ('Jacd'),('Mack');

insert into my_copy(name) select name from my_copy;

-- �߼���ѯ --
-- ȥ���ظ�
select distinct * from my_copy;

-- ����
select name as name1,name as name2 from my_copy;

-- ����ѯ
select * from my_copy��my_increase;

-- ��̬����
select * from (select name,pass from my_increase) as increase;

-- ����
select * from my_class group by class_id;
--ʹ�þۺϺ���
select class_id,count(*),max(age),min(scrore),avg(scrore) from my_class group by class_id;
select class_id,group_concat(name),count(*),max(age),min(scrore),avg(scrore) from my_class group by class_id;

-- �����
select class_id,scrore,group_concat(name),count(*) from my_class group by class_id,scrore;
-- ��������(asc����desc����)
select class_id,scrore,group_concat(name),count(*) from my_class group by class_id desc,scrore asc;

-- ����ͳ��
select class_id,count(*),group_concat(name) from my_class group by class_id desc with rollup;
select class_id,scrore,group_concat(name),count(*) from my_class group by class_id desc,scrore asc with rollup;

-- having
select class_id,count(*) as number,group_concat(name) from my_class group by class_id having number>=2;
select class_id,count(*),group_concat(name) from my_class group by class_id having count(*)>=2;

-- order by(����)
select * from my_class order by scrore desc;
select * from my_class order by scrore desc,class_id desc;

-- limit --
select * from my_class limit 3;
-- ��ҳ
select * from my_class limit 0,3;

-- �������� --
select int_1+int_2,int_4/3 from my_numbers;

-- �Ƚ����� --
select '1' <=> 1,0.02 <=> 0;
select * from my_class where class_id between 2 and 3;

-- �߼����� --(and,or,not)
select * from my_class where class_id >=2 and class_id <=3;
select * from my_class where class_id >=2 and class_id <=3;

-- in ����� --
select * from my_class where class_id in ('1','3');

-- is ����� --
select * from my_class where age is not null;

-- like --

select * from my_class where hobbies like 's%';
select * from my_class where name like 'M____';

-- ���ϲ�ѯ --
-- ��Ҫʹ��order by ����ʹ�����ź�limit
(select * from my_class where sex = 'male'order by class_id asc limit 8)
union
(select * from my_class where sex = 'female' order by class_id desc limit 8);

-- ���Ӳ�ѯ --
-- ��������
select * from my_pri3 cross join my_class;

-- ������
select * from my_class inner join my_test on my_class.class_id=my_test.id;
select * from my_test as m inner join my_class as t on m.id=t.class_id;

-- ������ --
-- ��������
select * from my_test as m left join my_class as t on m.id=t.class_id;
-- ������
select * from my_test as m right join my_class as t on m.id=t.class_id;

-- �Ӳ�ѯ --
-- ������ѯ��Mack ���ڰ༶������ ��
select * from my_test where id = (select class_id from my_class where name = 'Mack');
-- ���Ӳ�ѯ ����ѧ���İ༶��
select name from my_test where id in (select class_id from my_class);
-- ���Ӳ�ѯ (������С��������С)
select * from my_class where (age,scrore) = (select min(age),min(scrore) from my_class);
-- ���Ӳ�ѯ��ÿ����ɼ����ģ�
select * from (select * from my_class order by scrore asc limit 10) as tmp group by class_id;
-- exists (��ѧ���İ༶)
select * from my_test as c where exists (select class_id from my_class as s where s.class_id = c.id);

-- �ؼ��� --
-- in
select * from my_test where id in (select class_id from my_class);
-- any
select * from my_test where id =any (select class_id from my_class);
select * from my_test where id <>any (select class_id from my_class);
-- some ͬany
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
type varchar(10) not null comment'�˺�����',
account varchar(20) comment'�˺�',
password varchar(20) comment'����',
phonenum varchar(20) comment'���ֻ���',
remark text comment'��ע',
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
                    httpUserModel.setMessage("�������");
                }
            }else{
                httpUserModel.setResult("fail");
                httpUserModel.setMessage("�˺���Ϣ�����ڣ�");
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