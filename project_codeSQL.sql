set SERVEROUTPUT on

--Q2
-- create table salary logs 
create table salary_log (
    emp_id       number ,
    tr_date      DATE,
    tr_user      varchar2(100),
    salary_bfr   number,
    salary_aftr  number
);
----------------------------------------------

--4 
-- create table setup 
CREATE TABLE emp_sal_elms_setup (
  sal_cat     varchar2(1),
  elm_id      number,
  elm_desc    varchar2(50),
  elm_sign    char(1),
  elm_prc_val number
);

-- create table transactions --Emp_id , Sal_cat , elm_id   , elm_amt_val , trans_month {Month_last_day}
create table dist_emp_sal_elms_trans (
  Emp_id        number,           
  Sal_cat       varchar2(1),      
  elm_id        number,          
  elm_amt_val   number,          
  trans_month   date              
);

-- i made procedure call it insert all data 
create or replace procedure insert_emp_sal_elms_setup is 
begin 
insert into emp_sal_elms_setup values ('A' , 1 , 'income_tax' , '-' , .20);
insert into emp_sal_elms_setup values ('A' , 2 , 'soc_ins' , '-' , .09);
insert into emp_sal_elms_setup values ('A' , 3 , 'Med_ins' , '-' , .05);
insert into emp_sal_elms_setup values ('A' , 4 , 'other_ded' , '-' , .05);
insert into emp_sal_elms_setup values ('A' , 5 , 'mob_allw' , '+' , .03);
insert into emp_sal_elms_setup values ('A' , 6 , 'trns_allw' , '+' , .10);

insert into emp_sal_elms_setup values ('B' , 1 , 'income_tax' , '-' , .22);
insert into emp_sal_elms_setup values ('B' , 2 , 'soc_ins' , '-' , .10);
insert into emp_sal_elms_setup values ('B' , 3 , 'Med_ins' , '-' , .08);
insert into emp_sal_elms_setup values ('B' , 4 , 'other_ded' , '-' , .07);
insert into emp_sal_elms_setup values ('B' , 5 , 'mob_allw' , '+' , .05);
insert into emp_sal_elms_setup values ('B' , 6 , 'trns_allw' , '+' , .12);

insert into emp_sal_elms_setup values ('C' , 1 , 'income_tax' , '-' , .25);
insert into emp_sal_elms_setup values ('C' , 2 , 'soc_ins' , '-' , .10);
insert into emp_sal_elms_setup values ('C' , 3 , 'Med_ins' , '-' , .07);
insert into emp_sal_elms_setup values ('C' , 4 , 'trns_allw' , '+' , .15);

insert into emp_sal_elms_setup values ('D' , 1 , 'income_tax' , '-' , .27);
insert into emp_sal_elms_setup values ('D' , 2 , 'soc_ins' , '-' , .14);
insert into emp_sal_elms_setup values ('D' , 3 , 'Med_ins' , '-' , .07);
insert into emp_sal_elms_setup values ('D' , 4 , 'instnv_allw' , '+' , .25);

COMMIT;
end;

-- excute procedure that insert data in the table 
execute insert_emp_sal_elms_setup;

---------------------------------------------------------------------------------------------------------------------

--a- view 
--create view to get data form it 

create or replace view get_emp_sal_data as 

-- join betwwen employye table and table transaction to get data of each employee 

select E.employee_id , E.first_name ||  ' ' || E.last_name as full_name, D.sal_cat as salary_category,E.salary ,
   D.elm_amt_val as amount_dec, E.salary+(nvl(sum(D.elm_amt_val),0)) as Actual_sal_after_elm 
 
 from employees  E join dist_emp_sal_elms_trans D
   on E.employee_id = D.Emp_id
     
group by   E.employee_id, E.first_name, E.last_name, E.salary,D.sal_cat, D.elm_amt_val


-- run view 

select * from get_emp_sal_data

--------------------------------------------------------------------

--Q12

--cretae data table to but all formates on it 
create table date_format_data(
formate_id number,
formate   varchar(200)

);

--create procedure call it when i need to insert data or add more records formate
create or replace procedure insert_data_to_format_table is 
begin 
 insert into date_format_data values (1, 'DD-MM-YYYY');
 insert into date_format_data values (2, 'MM-DD-YYYY');
 insert into date_format_data values (3, 'Mon, DD / YYYY');
 insert into date_format_data values (4, 'YYYY/MM/DD');
 insert into date_format_data values (5, 'Day, DD Month YYYY');
 insert into date_format_data values (6, 'DD-Mon-YY');
 insert into date_format_data values (7, 'Month DD, YYYY');
COMMIT;
end;

--call procedure to insert data 
execute insert_data_to_format_table;

--------------------------------------------
--Q13 
create or replace  type sal_result as object(
  flag_top_sal  number,
  comp_top_sal   number
);

create table Emps_counts (
    tr_number         number,
    tr_date           date,
    emp_id            number,
    comp_top_sal      number(15,2),
    emp_dept_top_sal  number(15,2),
    emp_job_top_sal   number(15,2),
    emp_loc_top_sal   number(15,2),
    emp_cat_top_sal   number(15,2)
);

---------------------------------------

--Q14
--14 



create table Prem_H (
  itm_id       varchar2(50), -- item ID
  itm_price    number,       -- item price 
  prms_no      number,       -- number of Premium
  dep_amount   number,       -- deposite amount
  disc_amount  number,       -- discount amount           
  mop          char(1),      -- mode of payment
  inv_no       number        -- number of invoice
);


create table  Prem_D (
  item_id   varchar2(100),  -- item id   
  prm_no    number,         --premium number
  prm_amt   number,         --premium amount         
  prm_date  date,           --premium date
  prm_flag  char(1)         --premium flag           
);


-- crete sequence to take value to ivoices 
create sequence seq_invoices_number 
 start with 10000
 increment by 1
 nocache
 nocycle



-------------
--15 in BDA
create or replace directory  export_dir AS '/home/oracle/Desktop/oracle_Sql_files';
GRANT READ, WRITE ON DIRECTORY export_dir TO hr;
-------------------------------------------------



-- create package include all my functions and procedures 

create or replace package Eman_PKG is 

--Q1
function  increase_emp_sal_check(Emp_ID  employees.employee_id%type , incr_flag boolean default false , incr_value number default 0) return boolean;

--Q2
procedure increase_emp_sal(Emp_ID number , incr_flag boolean , incr_value number) ; 


--Q3
function Is_number(p_val  IN varchar2 default null) return varchar2;


--Q4-part1
function get_sal_cat(emp_sal employees.salary%type)  return varchar2;


--Q4-part2
procedure dist_emp_sal_elm_pro(emp_id  number);

--Q5
function get_full_address(p_id employees.employee_id%type , P_flag varchar2 ) return varchar2;

--Q6
function get_emp_count_by(p_value varchar2 , p_ref varchar2 ) return number;

-- Q7 
function Get_sal_diff(Emp_id  employees.employee_id%type, lev number )return number;


--Q8
function is_magaer(p_emp_id employees.employee_id%type , flag varchar2) return varchar2;

--Q9
function  get_sal_weight(p_emp_id employees.employee_id%type , flag varchar2) return varchar2;


--Q10
function get_dept_name(p_id employees.employee_id% type , flag varchar2) return varchar2 ;


--Q11
function Get_Manager_name(p_id employees.employee_id%type , flag varchar2) return varchar2;


--Q12
function My_to_char(p_Date Date , p_formate_id date_format_data.formate_id%type) return varchar2;


--Q13
function get_top_sal ( p_emp_id employees.employee_id%type, flag varchar2) return sal_result;

--Q14
procedure calc_premium(p_itm varchar2, p_price number , p_months number,p_dep number, p_disc number , p_mod varchar2);


--Q15
 procedure export_table_to_csv( p_table_name in varchar2, p_file_name  in varchar2);
end Eman_PKG;







create or  replace package body Eman_PKG is 
--Q1
-- function return true or false based on conditions
-- sal after increase should be between min_salary and Max_salary of job  
-- Sal should not be greater than his direct manager Salary  
function  increase_emp_sal_check(Emp_ID  employees.employee_id%type , incr_flag boolean default false , incr_value number default 0) return boolean is
temb_sal employees.salary%type;
min_sal employees.salary%type;
max_sal employees.salary%type;
manger_sal employees.salary%type;
temb_val employees.salary%type;
V_job_id employees.job_id%type;
begin

-- retrive salary with Emp_ID 
select salary , job_id into temb_sal,V_job_id from employees
where employee_id = Emp_ID;



-- Direct manger salary 
-- could me made using sub querie same cost of time in our case 1 employee
select m.salary  into manger_sal from employees E 
join employees M on E.manager_id = M.employee_id
where E.employee_id = Emp_ID;

dbms_output.put_line(manger_sal);
-- min and  -----??????? max salary of job 
select min_salary , max_salary into min_sal,max_sal from jobs where job_id =V_job_id;
dbms_output.put_line(min_sal);
dbms_output.put_line(max_sal);

-- varible cost memory but make code more readable 
temb_val:=(temb_sal + incr_value);
 dbms_output.put_line(temb_val);
   
 --return true if condition valid otherwise return false 
return  (temb_val > min_sal and temb_val < max_sal and temb_sal <= manger_sal);


-- handel if emp_id not found or manger id 
exception
  when  NO_DATA_FOUND then 
     dbms_output.put_line('Employee ID not found.');
    return false;
  when others then 
    dbms_output.put_line('Unexpected error: ' || SQLERRM);
    return false;
end;


--Q2
-- procedure call function and check if true update salary 
-- flag ????????????????????? made it using boolen not using flag 
 procedure increase_emp_sal(Emp_ID number , incr_flag boolean , incr_value number)  is 
  salary_bfr   number;
  salary_aftr  number;
begin 

-- condition on return value of function 
if increase_emp_sal_check(Emp_ID  , incr_flag  , incr_value ) then 

-- get value of salary befor update 
   select salary into salary_bfr from employees where employee_id= Emp_ID;
   
   salary_aftr:=(salary_bfr+incr_value);

 -- update value in case of valid conditions 
    update employees 
       set salary = salary_aftr
       where employee_id=Emp_ID;

 -- propmt that salary updated       
     DBMS_OUTPUT.PUT_LINE('Updated  Succesfuly ');

-- insert log values into taple 
   insert into salary_log values (Emp_ID, SYSDATE, USER, salary_bfr, salary_aftr);

-- no valid upadtes          
else 
     DBMS_OUTPUT.PUT_LINE('Invalid increase conditions not valid ');
end if;   
end;



--Q3 
--create function check if it number or not 
function Is_number(p_val  IN varchar2 default null) return varchar2 is
begin
 
 -- convert input to number and check if conversion completed correct 
 --this this number else not number
 if to_number(p_val) is not null then 
     return 'Yes';
 else 
    return 'No';
 end if;
 
 -- handle erors happen while conversion
exception 
  when value_error then 
      return 'No';
  when others then
     dbms_output.put_line('Sql error '||SQLERRM);
end;


--Q4-part1
-- create function that return salary category
function get_sal_cat(emp_sal employees.salary%type)  return varchar2 is
begin 

-- each slary value take category A or B or C or C
if emp_sal <5000 then 
   return 'A';
   
elsif emp_sal between 5000 and 10000 then 
   return 'B';
   
elsif emp_sal between 1000 and 15000 then 
   return 'C';   
else 
    return 'D';
    
end if;    
end;



-- Q4-part2
-- create procedure get ecah salary category then calculate each category actions like income_tax ,soc_ins ..etc 
procedure dist_emp_sal_elm_pro(emp_id  number) is 
emp_sal employees.salary%type;
V_sal_cat varchar2(1);
rec_setup    emp_sal_elms_setup%rowtype;

begin 
-- only thing i know emp_id  i can get value of salary to make calculation on it 
-- get salary
 select salary into emp_sal from employees 
 where employee_id = emp_id;
 
 ---- get salary category
 V_sal_cat:=get_sal_cat(emp_sal);
 
 ----- get records based on  salary catergory
 for rec in ( select * from emp_sal_elms_setup where sal_cat = V_sal_cat) loop
  declare
    v_amt number := emp_sal * rec.elm_prc_val;
  begin
    if rec.elm_sign = '-' then v_amt := -v_amt;
    end if;

    insert into dist_emp_sal_elms_trans values ( emp_id, v_sal_cat, rec.elm_id, v_amt, last_day(sysdate));
  end;
end loop;
         
end;


--Q5
--departments  → loactions 
--employees  → departments → locations
-- create function that get full adress of department D or employee E 
function get_full_address(p_id employees.employee_id%type , P_flag varchar2 ) return varchar2 is 

V_full_addres varchar2(1000);


begin 
-- get full adress of employee by join tables employees  , departments , locations
if P_flag ='E' then 
        select 'Location-->  '|| L.location_id || '  ' || 'Street-->  '|| L.street_address || '  '||'Postal code-->   '|| L.postal_code 
             || '   '||'City-->  '|| L.city || '  ' || 'State-->  '||L.state_province || '  '||'Country-->  '|| L.country_id  into V_full_addres
               from employees E join departments D on E.department_id =D.department_id 
     
               join locations L on D.location_id = L.location_id
               where employee_id = p_id;
        
--get full adress of department by join tables departments , locations        
elsif P_flag ='D' then    
      
           select 'Location-->  '|| L.location_id || '  ' || 'Street-->  '|| L.street_address || '  '||'Postal code-->   '|| L.postal_code 
             || '   '||'City-->  '|| L.city || '  ' || 'State-->  '||L.state_province || '  '||'Country-->  '|| L.country_id  into V_full_addres
              from  departments D join  locations L on d.location_id = L.location_id
                where  D.department_id = p_id;

-- check of invalid identifier        
else 
   V_full_addres:='Invalid identifier E or D';
end if;
 
 -- return adress
 return V_full_addres;   
 
 -- exception to handle errors 
 exception 
    when NO_DATA_FOUND then 
        return 'No data with this id ';
     when others   then 
     return  'Sql error '||SQLERRM;
end;



-- Q6
function get_emp_count_by(p_value varchar2 , p_ref varchar2 ) return number is 
V_count  number ;


begin 
V_count :=-1;

-- get count of employees based on conditions if department 
  if p_ref = 'D' then
    select count(*) into V_count from employees 
    where department_id = to_number(p_value);

-- if job id
  elsif p_ref = 'J' then
    select count(*) into V_count from employees 
    where job_id = p_value;

-- if manager 
  elsif p_ref = 'M' then
    select count(*) into V_count from employees 
    where manager_id = to_number(p_value);
   
-- if salary ategory      
  elsif   p_ref ='S' then 
    select count(*) into V_count from employees 
    where get_sal_cat(salary) =p_value;
 
-- if company  
  elsif   p_ref ='C' then 
    select count(*) into V_count from employees;
  
    --????????????????????
  else 
     return V_count;
 end if ;   
return V_count;

-- exception to handle errors 
 exception 
    when NO_DATA_FOUND then 
        return 'No data with this id ';
     when others   then 
     return  'Sql error '||SQLERRM;

end;


--Q7
-- function return diff of salary between employee and his <nth Leveln>manager 
function Get_sal_diff(Emp_id  employees.employee_id%type, lev number )
return number is 
V_salary_emp employees.salary%type;
V_salary_manger employees.salary%type;
V_manager_id  employees.manager_id%type;
begin 

-- slect manager id that manage passed employee id 
select salary , manager_id into V_salary_emp ,V_manager_id from employees where employee_id = Emp_id; 
 
-- loop to get nth level manager 1 or 2 or 3 level   
for i in 1..lev loop 

-- check if not find manager id is null so no manager at this level i and raise error 
if V_manager_id is null then   
    raise_application_error(-20001, 'No manager  at level ');
 end if;
   
-- other wise i get this manager salary at i th level otherwise i get next level id to reach nth goal    
if i=lev then 
      select salary into V_salary_manger from employees where employee_id = V_manager_id;
 else 
      select manager_id into V_manager_id from employees where employee_id = V_manager_id;
 end if;
end loop;

-- return diff salary 
return abs(V_salary_manger - V_salary_emp);
end;


--Q8
-- create function to check if emp id is manager or not 
 function is_magaer(p_emp_id employees.employee_id%type , flag varchar2) return varchar2 is 
V_manager_id employees.manager_id%type;
begin 

-- inatialize value with null
V_manager_id:=null;

--check passed employee id manage at least one employee to manage 
if  flag ='E' then 
    select manager_id into V_manager_id from employees where employee_id = p_emp_id;
 
-- check passed  employee id manage at least one department to manage       
elsif flag = 'D' then   
     select manager_id into V_manager_id from departments where manager_id = p_emp_id;

-- invalid identifier E or D         
else 
    return 'Invalid identifier';
end if;    

-- check if manager id is not null 
 if  V_manager_id is not null then 
        return 'Yes  manager  ';
 else 
      return 'No , Not a manager ';
 end if;
 
-- exception ti handle if no data exist with passed id  
 exception 
    when NO_DATA_FOUND then 
        return 'No manager with this id ';
     when others   then 
     return  'Sql error '||SQLERRM;
end;



--Q9 
-- function calculate salary of employee based on flag JOB , department , company , manager
function  get_sal_weight(p_emp_id employees.employee_id%type , flag varchar2) return varchar2 is 

V_emp_sal  employees.salary%type;
V_emp_total_sal  employees.salary%type;

begin 

-- select slary of passed employee id 
select salary into V_emp_sal from employees where employee_id = p_emp_id ;


-- if weight according to his  department 
if flag ='D' then 
   select sum(salary)into V_emp_total_sal from employees
   where department_id=(select department_id from employees where employee_id = p_emp_id);

-- if weight according to his job 
elsif flag = 'J' then
  select sum(salary) into V_emp_total_sal from employees
  where job_id = (select job_id from employees where employee_id = p_emp_id);

-- if weight according to his manager 
elsif flag = 'M' then 
   select sum(salary) into V_emp_total_sal from employees
  where manager_id = (select manager_id from employees where employee_id = p_emp_id);

-- if weight according to his company 
elsif flag = 'C' then 
 select sum(salary) into V_emp_total_sal from employees;
 
else 
  return 'Invalid identifier';
end if;
-- handel divide by zero 

 if V_emp_total_sal is null or V_emp_total_sal = 0 then
    return 'Invalid calculation to weight';
  end if;

  
  return (to_char(round(V_emp_sal / V_emp_total_sal,7)));

-- exception to catch errors 
exception 
    when NO_DATA_FOUND then 
        return 'No manager with this id ';
     when others   then 
        return  'Sql error '||SQLERRM;
end ;


--Q10
-- create function return name of department D or name of department of employee E 
function get_dept_name(p_id employees.employee_id% type , flag varchar2) 
return varchar2 is 
V_name varchar2(50); --????????

begin 

-- inatialize value with null
V_name:=null;

---- cheeck if user need department name of E or D
if flag ='E' then 

 --select department name with spesific employee
   select department_name into V_name from departments D join 
      employees E on  D.department_id = E.department_id
      where employee_id=p_id;
      
elsif flag='D' then 
 --select department name with spesific employee
    select department_name into V_name from departments 
       where department_id = p_id ;

--check invalid flag E or D
else 
   V_name:= 'invalid identifier';   
end if;
 
-- return name if data exist or return that there is no dept name with this id 
return V_name;
/*
if  V_name is not null then 
        return V_name;
else 
      return 'No namee with this id ';
end if;
*/

 
 -- exception ti handle if no data exist with passed id   
 exception 
    when NO_DATA_FOUND then 
        return 'No name  with this id ';
     when others   then 
     return  'Sql error '||SQLERRM;
end;



--Q11
-- function get manager full name 1- manager of employee E 2- manager of departmen D
function Get_Manager_name(p_id employees.employee_id%type , flag varchar2) 
return varchar2 is 
V_name_manager varchar2(100);
begin 

-- inatialize value with null
V_name_manager:=null;

-- cheeck if user need manager name of E or D
if flag ='E' then 
   
-- slect manager of employee
   select first_name ||' '|| last_name   into V_name_manager from employees where
   employee_id =(select manager_id from employees where employee_id=p_id);
   
elsif flag='D' then 

-- slect manager of Department 
   select first_name || ' ' || last_name  into V_name_manager from employees where
   employee_id =(select manager_id from departments where department_id=p_id) ;

--handle if flag not exist 
else 
   V_name_manager:= 'invalid identifier';
end if;

-- check if manager name not exist so V_name still have value null 
return V_name_manager;

/*
if  V_name_manager is not null then 
    return V_name_manager;     
else 
     return 'no anme with this id ';
end if;
*/
 
 -- exception to handle if no data with passed id   
 exception 
   when NO_DATA_FOUND then 
        return 'No name  with this id ';
   when others   then 
        return  'Sql error '||SQLERRM;
end;



--Q12
-- craete function to take date and return it with spesific formate 
function My_to_char(p_Date Date , p_formate_id date_format_data.formate_id%type) return varchar2 is 
V_formate date_format_data.formate%type;
begin 

-- select formate based on formate passed number 
select formate into V_formate from date_format_data
where formate_id = p_formate_id ;

--return date with determined formate 
return to_char(p_Date , V_formate);
 
--exception to handle if id not exist 
exception 
   when NO_DATA_FOUND then 
        return 'No date  with this id ';
   when others   then 
        return  'Sql error '||SQLERRM;
end;

-- Q13
-- return max salry department , job , location ...etc 
 function get_top_sal ( p_emp_id employees.employee_id%type, flag varchar2) return sal_result is
  
    v_dep_id employees.department_id%type;
    v_job_id employees.job_id%type;
    v_sal employees.salary%type;
    v_sal_cat varchar2(5);
    v_loc_id departments.location_id%type;

    v_max_sal number(15,2);
    v_max_sal_c number(15,2);
    emp_dept_top_sal  number(15,2);
    emp_job_top_sal   number(15,2);
    emp_loc_top_sal   number(15,2);
    emp_cat_top_sal   number(15,2);

begin

-- get employee details
select department_id, job_id, salary into v_dep_id, v_job_id, v_sal from employees where employee_id = p_emp_id;

-- get salary category 
 v_sal_cat := get_sal_cat(v_sal);
 
 
-- get max salary in department  
   select max(salary) into emp_dept_top_sal from employees where department_id = v_dep_id;
 
-- get max salary in job        
   select max(salary) into emp_job_top_sal from employees where job_id = v_job_id;
    
-- get max salary in loaction     
 select location_id into v_loc_id from departments where department_id = v_dep_id;
      
        select max(e.salary) into emp_loc_top_sal from employees e
        join departments d on e.department_id = d.department_id
        where d.location_id =  v_loc_id;
        
 -- get max salary based in salary category        
 select max(salary) into emp_cat_top_sal from employees
        where get_sal_cat(salary) = v_sal_cat;
    
-- get max salary in company
 select max(salary) into v_max_sal_c from employees;
    
 
-- insert values in table log     
insert into Emps_counts values (p_emp_id+1, sysdate , p_emp_id,v_max_sal_c,emp_dept_top_sal,emp_job_top_sal,emp_loc_top_sal,emp_cat_top_sal);
     

-- function return value based on flag passed to function          
    if flag = 'PD' then
         return sal_result(emp_dept_top_sal, v_max_sal_c);
      
    elsif flag = 'PJ' then
        return sal_result(emp_job_top_sal, v_max_sal_c);

    elsif flag = 'PL' then
   
       return sal_result(emp_loc_top_sal, v_max_sal_c);

    elsif flag = 'PS' then 
         return sal_result(emp_cat_top_sal, v_max_sal_c);

    else
       dbms_output.put_line('Invalid identifier  ');
        return sal_result(0, 0);
    end if;

   
-- exception to handle errors    
exception
    when no_data_found then
       dbms_output.put_line('No data found  ');
        return sal_result(0, 0);
    when others then
       dbms_output.put_line('Error: ' || sqlerrm);
        return sal_result(-1, -1);

end;

--Q14
-- crete procedure calculate premium
procedure calc_premium(p_itm varchar2, p_price number , p_months number,p_dep number, p_disc number , 
p_mod varchar2) is 

V_payment_mode number;
V_number_premiums number;
V_after_dis_dep number;
V_premium_date date;
begin 

-- check on payment mode monthely
if p_mod ='M' then 
   V_payment_mode:=1;

-- check on payment mode quarter   
elsif p_mod ='Q' then 
    V_payment_mode:=3;

-- check on payment mode each 6 months    
elsif p_mod ='S' then 
     V_payment_mode:=6;

-- check on payment mode anual      
elsif p_mod='Y' then 
    V_payment_mode:=12;

-- check on invalid identifier 
else 
    RAISE_APPLICATION_ERROR(-20001, 'Invalid Mode ');
end if;


-- calculate number of premium 
V_number_premiums :=(p_months/V_payment_mode);


-- insert  data in history table 
insert into Prem_H values (p_itm,p_price,V_number_premiums,p_dep,p_disc,p_mod,seq_invoices_number.nextval);

-- calculate money after decrese deposite or discount
V_after_dis_dep:= p_price- nvl(p_dep,0)-nvl(p_disc,0);

-- insert if deposite
if p_dep >0 then
  insert into prem_d VALUES(p_itm, 0, p_dep, SYSDATE, 'D');
end if;

-- insert if discount
if p_disc >0 then 
  insert  into prem_d values(p_itm, 0, p_disc, SYSDATE, 'C');
end if;

-- insert data in table pem_d each premium
for i in 1 .. V_number_premiums loop
  V_premium_date := add_months(last_day(SYSDATE), i * V_payment_mode);
  insert into Prem_D values(p_itm, i, Round(V_after_dis_dep/V_number_premiums,4), V_premium_date, 'P');
end loop;

-- exception to handel errors 
exception
    when no_data_found then
       dbms_output.put_line('No data found ');
     
    when others then
       dbms_output.put_line('Error: ' || sqlerrm);
     
end;



--Q15
--export file 
 procedure export_table_to_csv( p_table_name in varchar2, p_file_name  in varchar2)
is
    v_file        utl_file.file_type;
    v_dir         constant varchar2(30) := 'export_dir';
    v_sql         varchar2(1000);
    v_cursor      integer;
    v_col_cnt     integer;
    v_desc_tab    dbms_sql.desc_tab;
    v_col_val     varchar2(4000);
    v_line        varchar2(32767);
    v_status      integer;
begin
    v_file := utl_file.fopen(v_dir, p_file_name, 'w', 32767);

    v_sql := 'select * from ' || p_table_name;
    v_cursor := dbms_sql.open_cursor;
    dbms_sql.parse(v_cursor, v_sql, dbms_sql.native);
    dbms_sql.describe_columns(v_cursor, v_col_cnt, v_desc_tab);

    for i in 1 .. v_col_cnt loop
        dbms_sql.define_column(v_cursor, i, v_col_val, 4000);
    end loop;

    v_line := '';
    for i in 1 .. v_col_cnt loop
        v_line := v_line || case when i > 1 then ',' end || v_desc_tab(i).col_name;
    end loop;
    utl_file.put_line(v_file, v_line);

    v_status := dbms_sql.execute(v_cursor);
    while dbms_sql.fetch_rows(v_cursor) > 0 loop
        v_line := '';
        for i in 1 .. v_col_cnt loop
            dbms_sql.column_value(v_cursor, i, v_col_val);
            v_line := v_line || case when i > 1 then ',' end || replace(v_col_val, ',', '');
        end loop;
        utl_file.put_line(v_file, v_line);
    end loop;

    dbms_sql.close_cursor(v_cursor);
    utl_file.fclose(v_file);

    dbms_output.put_line('export  successfully.');

exception
    when others then
        if dbms_sql.is_open(v_cursor) then
            dbms_sql.close_cursor(v_cursor);
        end if;
        if utl_file.is_open(v_file) then
            utl_file.fclose(v_file);
        end if;
        dbms_output.put_line('error: ' || sqlerrm);
end;
end Eman_PKG;


-------------------------------------------------------------------



--TEST CASES 
--Q2
-- run tests 
execute EMAN_PKG.increase_emp_sal(111, TRUE, 11);-- invalid conditions 
execute EMAN_PKG.increase_emp_sal(106, TRUE, 11);  -- updated succesfully 

/
---------------------------------------------------------------------------------
--3
-- run tests 

begin 
dbms_output.put_line( EMAN_PKG.Is_number('123')); --yes
dbms_output.put_line( EMAN_PKG.Is_number('123x')); --no 
end;
-----------------------------------------------------------------------------------
--4 
begin
 EMAN_PKG.dist_emp_sal_elm_pro(139);
end;
select * from dist_emp_sal_elms_trans 
-----------------------------------------------------------------------------
--5
begin 
dbms_output.put_line(EMAN_PKG.get_full_address(140, 'D'));
dbms_output.put_line(EMAN_PKG.get_full_address(140, 'E'));
end;


-----------------------------------------------------------------------------
--6
begin
 dbms_output.put_line(EMAN_PKG.get_emp_count_by ( 10,'D')); -- emp count by department,
 dbms_output.put_line(EMAN_PKG.get_emp_count_by ('IT_PROG','J')); --  emp count by job 
 dbms_output.put_line(EMAN_PKG.get_emp_count_by (100  ,'M')); --emp count by Manager
 dbms_output.put_line(EMAN_PKG.get_emp_count_by ('A' ,'S') );-- salary category
end;


-------------------------------------------------------------------------
--7

begin 
 --dbms_output.put_line(EMAN_PKG.Get_sal_diff(111, 4));--  no level manfer 4 
dbms_output.put_line(EMAN_PKG.Get_sal_diff(111, 3));--   level manfer 3 
end ;

-----------------------------------------------------------------------------------------------
-- 8
begin 
dbms_output.put_line(EMAN_PKG.is_magaer(150, 'E'));
end ;
--------------------------------------
-- 9
begin 
 --dbms_output.put_line(EMAN_PKG.get_sal_weight(111, 'J'));
 --dbms_output.put_line(EMAN_PKG.get_sal_weight(111, 'D'));
 --dbms_output.put_line(EMAN_PKG.get_sal_weight(111, 'M'));
   dbms_output.put_line(EMAN_PKG.get_sal_weight(111, 'Cx'));
end ;
----------------------------------------

--10
begin 
dbms_output.put_line(EMAN_PKG.get_dept_name(111, 'x'));
dbms_output.put_line(EMAN_PKG.get_dept_name(111, 'D'));
end ;
--------------------------------------------------------------
--11 

begin 
dbms_output.put_line(EMAN_PKG.Get_Manager_name(50, 'D'));
dbms_output.put_line(EMAN_PKG.Get_Manager_name(111, 'E'));
end ;

-------------------------------------------------------------------------------------------------
--12
begin 
dbms_output.put_line(EMAN_PKG.My_to_char(SYSDATE, 2)); -- return with date formate 'MM-DD-YYYY'
dbms_output.put_line(EMAN_PKG.My_to_char(SYSDATE, 8)); -- output  'No data with this id'
end ;
---------------------------------------------------------------------------------------------------
--13
declare
    v_result sal_result;
begin
    v_result := EMAN_PKG.get_top_sal(130, 'PD');  -- test with employee_id = 101 and flag = 'pd'

    dbms_output.put_line('Flag Top Salary: ' || v_result.flag_top_sal);
    dbms_output.put_line('Company Top Salary: ' || v_result.comp_top_sal);
end;

select * from Emps_counts

-------------------------------------------------------------------------------------
--14 

begin 
EMAN_PKG.calc_premium('iphone-16' , 70000 , 36 ,1000,2000, 'Q')  ;
end;

select * from Prem_H
select * from Prem_D
-------------------------------------------------------------------------------------
--15
begin
    export_table_to_csv('jobs', 'jobs.csv');
end;
/

