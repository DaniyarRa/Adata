create table Employees
(
    id        serial primary key,
    surname  varchar(20) NOT NULL,
    name varchar(20) NOT NULL,
    fathersName varchar(20),
    birthDate date NOT NULL,
    gender    varchar(10) check ( gender in ('male' , 'female'))
);


insert into employees(surName,name, fathersName, birthDate, gender) VALUES ('Райымбеков', 'Данияр', 'Әкімжанұлы', '2003-10-03', 'male');
insert into employees(surName,name, fathersName, birthDate, gender) VALUES ('Рашидов', 'Давид', 'Манукян', '1985-01-16', 'male');
insert into employees(surName,name, fathersName, birthDate, gender) VALUES ('Крысовец', 'Давид', 'Микеланджело', '1999-06-06', 'male');
insert into employees(surName,name, fathersName, birthDate, gender) VALUES ('Tom', 'Cat', 'Apache', '1999-06-15', 'female');

create table Departments
(
    departmentName varchar(30) primary key,
    countOfEmployees int,
    idDepHead int,
    foreign key (idDepHead) references Employees(id)
);
--drop table employees
insert into Departments(departmentName, countOfEmployees, idDepHead) values ('Разработка', 0, 1);
insert into Departments(departmentName) values ('Снабжение');
insert into Departments(departmentName) values ('Кадры');
create table Career
(
    id int,
    departmentName varchar(30),
    role varchar(50),
    salary int check ( salary >= 60000 ),
    startAtRole date not null,
    primary key (id, departmentName),
    foreign key (id) references Employees(id),
    foreign key (departmentName) references Departments(departmentName)
);


insert into Career(id, departmentName, role, salary, startAtRole) VALUES (1,'Разработка', 'Инженер Данных', 500000, '2022-09-01');
insert into Career(id, departmentName, role, salary, startAtRole) VALUES (1,'Снабжение', 'Стажер', 200000, '2020-09-01');
insert into Career(id, departmentName, role, salary, startAtRole) VALUES (2,'Снабжение', 'Менеждер', 500000,'2021-09-01');
insert into Career(id, departmentName, role, salary, startAtRole) VALUES (3,'Снабжение', 'Дизайнер', 600000,'2021-09-01');
insert into Career(id, departmentName, role, salary, startAtRole) VALUES (3,'Кадры', 'Менеждер', 500000,'2019-09-01');
insert into Career(id, departmentName, role, salary, startAtRole) VALUES (4,'Разработка', 'Инженер Данных', 900000,'2022-04-01');
insert into Career(id, departmentName, role, salary, startAtRole) VALUES (4,'Кадры', 'Инженер Данных', 500000,'2022-01-01');

--delete from career;
create table Tasks
(
    taskId serial PRIMARY KEY,
    taskDefinition text not null,
    deadline date not null,
    done boolean not null
);

insert into Tasks(taskDefinition, deadline, done) values ('Find a supplier of bottled water', '2022-09-30', false)

create table Commands
(
    taskId int,
    id int,
    primary key (taskId, id),
    foreign key (taskId) references Tasks(taskId),
    foreign key (id) references Employees(id)
);

insert into Commands(taskId, id) VALUES (1 , 1)

-- Task 1

select surname, name, fathersName, salary,role from employees, career where employees.id = Career.id and Career.departmentName='Снабжение' and Employees.name='Давид';
-- Task2

select departmentName, avg(salary) as AverageSalary from career group by departmentName order by AverageSalary desc;

--Task3

CREATE OR REPLACE FUNCTION AverageSalary() RETURNS integer AS $$
        BEGIN
                return (select avg(salary) from career);
        END;
$$ LANGUAGE plpgsql;

--select AverageSalary();

select role, avg(salary) as AvS,
       Case WHEN avg(salary) > (select AverageSalary()) THEN 'Да'
            ELSE 'Нет'
       END as MoreThanAverage
from career group by role;

--Task4

CREATE OR REPLACE FUNCTION DepartmentHavingRole(i varchar(50)) RETURNS text[] AS $$
        DECLARE
        dep record;
        --deps TEXT[] := ARRAY[]::TEXT[];
        deps TEXT[] DEFAULT ARRAY[]::TEXT[];
        BEGIN
                for dep in select distinct departmentName from career where role = i
                    loop
                        deps = array_append(deps, dep.departmentName::TEXT);
                    end loop;
                return deps;
        END;

$$ LANGUAGE plpgsql;
--drop function departmenthavingrole(i varchar);
select distinct role, (select DepartmentHavingRole(role)), avg(salary) from career group by role;

--select DepartmentHavingRole('Дизайнер')