-- PHẦN 1: DDL – THIẾT KẾ CSDL
-- Tạo database
create database employee_management;
use employee_management;

-- Tạo bảng 1: Employees (Nhân viên)
create table employees (
	employee_id int primary key,
	full_name varchar(20) not null,
	email varchar(20) not null unique,
	phone_number varchar(10) unique,
	hire_date  date default (current_date),
	salary decimal(10,2) check(salary > 0)
);

-- Tạo bảng 2: Employee_Details (Thông tin nhân viên)
create table employee_details (
	detail_id int primary key,
	employee_id int unique,
    foreign key (employee_id) references employees(employee_id),
	citizen_id varchar(9) not null unique,
	address  varchar(20) not null,
	working_status varchar(10)
);

-- Tạo bảng 3: Departments (Phòng ban)
create table  departments  (
	department_id int primary key,
	department_name varchar(20) not null unique,
	description varchar(100)
);

-- Tạo bảng 4: Projects (Dự án)
create table  projects  (
	project_id int primary key,
	project_name varchar(30) not null,
	department_id int,
	foreign key (department_id) references departments(department_id),
	budget decimal(10,2) check(budget > 0),
	project_status varchar(10)
);

-- Tạo bảng 5: Work_Assignments (Phân công công việc)
create table  work_assignments  (
	assignment_id int primary key,
	employee_id int,
	project_id int,
    foreign key (employee_id) references employees(employee_id),
    foreign key (project_id) references projects(project_id),
	start_date date not null,
	deadline date not null,
    check (	deadline > start_date),
	completed_date date 
);

-- PHẦN 2: DML – INSERT, UPDATE, DELETE 
-- Câu 1 – INSERT

-- Bảng Employees
insert into employees values
(1,'Nguyen Van A','anv@gmail.com','0901234567','2022-01-15',12000000),
(2,'Tran Thi B','btt@gmail.com','0912345678','2021-05-20',18000000),
(3,'Le Van C','cle@yahoo.com','0922334455','2023-02-10',9500000),
(4,'Pham Minh D','dpham@hotmail.com','0933445566','2020-11-05',22000000),
(5,'Hoang Anh E','ehoang@gmail.com','0944556677','2023-01-12',15000000);

-- Bảng Employee_Details
insert into employee_details values 
(1,1,'123456789','Ha Noi','Active'),
(2,2,'234567890','Hai Phong','Active'),
(3,3,'345678901','Da Nang','Inactive'),
(4,4,'456789012','Ho Chi Minh','Active'),
(5,5,'567890123','Can Tho','Active');

-- Bảng Departments
insert into departments values 
(1,'IT','Phòng công nghệ thông tin'),
(2,'HR','Phòng nhân sự'),
(3,'Marketing','Phòng marketing'),
(4,'Finance','Phòng tài chính'),
(5,'Sales','Phòng kinh doanh');

-- Bảng Projects
insert into projects values
(1,'Website Company',1,50000000,'Doing'),
(2,'Recruitment 2025',2,20000000,'Pending'), 
(3,'Ads Campaign',3,30000000,'Doing'), 
(4,'Accounting System',4,45000000,'Done'), 
(5,'Customer Expansion',5,25000000,'Pending');

-- Bảng Work_Assignments
insert into work_assignments values
(101,1,1,'2024-01-10','2024-02-10',NULL),
(102,2,2,'2024-02-01','2024-03-01','2024-02-25'),
(103,2,3,'2024-03-05','2024-04-05',NULL),
(104,4,4,'2023-10-10','2023-12-10','2023-12-05'),
(105,5,5,'2024-04-01','2024-05-01',NULL);


-- Câu 2 – UPDATE & DELETE
update projects
set budget = budget + 5000000
where department_id = 1;

delete from work_assignments
where completed_date is not null and completed_date < '2024-1-01';

-- PHẦN 3: TRUY VẤN CƠ BẢN 

-- Câu 1 (5đ): Liệt kê các thông tin dự án gồm project_id, project_name, budget của những dự án thuộc phòng ban 'IT' và có ngân sách lớn hơn 30.000.000.
select project_id, project_name, budget 
from projects
where department_id = 1 and budget > 30000000;

-- Câu 2 (5đ): Liệt kê các thông tin nhân viên gồm employee_id, full_name, email của những nhân viên có ngày vào làm trong năm 2022 và email thuộc tên miền '@gmail.com'.
select employee_id, full_name, email,hire_date
from  employees 
where hire_date  > '2022-1-01' and hire_date  < '2022-12-31' and email like '%@gmail.com%';

-- Câu 3 (5đ): Liệt kê danh sách nhân viên gồm employee_id, full_name, salary, trong đó danh sách được sắp xếp theo lương giảm dần và chỉ hiển thị 3 nhân viên bắt đầu từ người thứ 2 (bỏ qua người lương cao nhất).
select employee_id, full_name, salary
from  employees 
order by salary desc
limit 3
offset 1;

-- PHẦN 4: TRUY VẤN NÂNG CAO

-- Câu 1 (6đ): Liệt kê các thông tin phân công gồm mã phân công, tên nhân viên, tên dự án, ngày bắt đầu, hạn hoàn thành, với dữ liệu được lấy từ các bảng liên quan và chỉ hiển thị các công việc chưa hoàn thành (completed_date IS NULL).
-- Work_Assignment  mã phân công,Ngày bắt đầu,Hạn hoàn thành
--  Employees ten nhân viên
-- Projects tên dự án 
select 
wa.assignment_id,
e.full_name,
-- p.project_name,
wa.start_date,
wa.deadline
from employees e
inner join  work_assignments wa on wa.employee_id = e.employee_id 
inner join projects p on p.project_id = wa.project_id
where wa.completed_date is null;

-- Câu 3 (7đ): Liệt kê tổng ngân sách dự án theo từng phòng ban gồm department_name và total_budget, chỉ hiển thị những phòng ban có tổng ngân sách lớn hơn 40.000.000.
select  e.employee_id, e.full_name,ed.working_status, p.budget
from employees e
inner join employee_details ed on  e.employee_id =  ed.employee_id
inner join  work_assignments wa on wa.employee_id = e.employee_id 
inner join projects p on p.project_id = wa.project_id
where ed.working_status = 'Active'  and p.budget > 40000000;

-- Câu 2 (7đ): Liệt kê tổng ngân sách dự án theo từng phòng ban gồm department_name và total_budget, chỉ hiển thị những phòng ban có tổng ngân sách lớn hơn 40.000.000.
select d.department_name, sum(p.budget) as total_budget
from departments d
inner join projects p on d.department_id = p.department_id
group by department_name
having total_budget > 40000000;

-- PHẦN 5: INDEX & VIEW 

-- Câu 1 (5đ): Tạo chỉ mục (index) tên idx_assignment_dates trên bảng Work_Assignments 
-- dựa trên hai cột start_date và completed_date
create index idx_assignment_dates 
on work_assignments (start_date, completed_date);

-- Câu 2 (5đ): Tạo khung nhìn (view) tên vw_overdue_assignments 
-- Hiển thị: mã phân công, tên nhân viên, tên dự án, ngày bắt đầu, hạn hoàn thành
-- Điều kiện: chưa hoàn thành (completed_date is null) và đã quá hạn (deadline < CURDATE())
create view vw_overdue_assignments as
select 
	wa.assignment_id,
	e.full_name,
	p.project_name,
	wa.start_date,
	wa.deadline
from work_assignments wa
inner join employees e on wa.employee_id = e.employee_id
inner join projects p on wa.project_id = p.project_id
where wa.completed_date is null 
  and wa.deadline < curdate();


-- PHẦN 6: TRIGGER (10 ĐIỂM)

-- Câu 1 (5đ): Viết trigger trg_after_assignment_insert khi thêm mới một phân công vào bảng work_assignments, cập nhật trạng thái dự án thành 'Doing'
delimiter //
create trigger trg_after_assignment_insert
after insert on work_assignments
for each row
begin
	update projects
	set project_status = 'Doing'
	where project_id = new.project_id;
end //
delimiter ;

-- Câu 2 (5đ): Viết trigger trg_prevent_delete_employee ngăn chặn việc xóa nhân viên nếu nhân viên đó vẫn còn công việc chưa hoàn thành (completed_date is null)
delimiter //
create trigger trg_prevent_delete_employee
before delete on employees
for each row
begin
	declare uncompleted_count int;
	select count(*) into uncompleted_count
	from work_assignments
	where employee_id = old.employee_id and completed_date is null;
	if uncompleted_count > 0 then
		signal sqlstate '45000' 
		set message_text = 'Không thể xóa nhân viên vì vẫn còn công việc chưa hoàn thành';
	end if;
end //
delimiter ;