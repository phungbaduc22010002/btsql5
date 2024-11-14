
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    name VARCHAR(255),
    age INT,
    salary DECIMAL(10, 2)
);


CREATE TABLE Department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(255) UNIQUE
);


CREATE TABLE Employee_Department (
    employee_id INT,
    department_id INT,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (department_id) REFERENCES Department(department_id),
    salary DECIMAL(10, 2),
    PRIMARY KEY (employee_id, department_id)
);


INSERT INTO Employee (employee_id, name, age, salary) VALUES
(1, 'PHUNG BA DUC', 30, 55000),
(2, 'Tran THi Anh', 27, 48000),
(3, 'PHam thi lan anh', 35, 70000),
(4, 'Pham trung kien ', 40, 60000);

INSERT INTO Department (department_id, department_name) VALUES
(1, 'Kế toán'),
(2, 'Kỹ thuật'),
(3, 'Nhân sự');

INSERT INTO Employee_Department (employee_id, department_id, salary) VALUES
(1, 1, 55000),
(2, 1, 48000),
(3, 2, 70000),
(4, 3, 60000),
(3, 1, 70000);



-- 1Liệt kê tất cả các nhân viên -- 
SELECT e.employee_id, e.name
FROM Employee e
JOIN Employee_Department ed ON e.employee_id = ed.employee_id
JOIN Department d ON ed.department_id = d.department_id
WHERE d.department_name = 'Kế toán';

-- 1-- 
SELECT e.employee_id, e.name, e.salary
FROM Employee e
WHERE e.salary > 50000;

-- các nhân viên có mức lương lớn hơn 50,0001-- 
SELECT e.employee_id, e.name, e.salary
FROM Employee e
WHERE e.salary > 50000;

-- Hiển thị tất cả các bộ phận và số lượng nhân viên trong từng bộ phận-- \
SELECT d.department_name, COUNT(ed.employee_id) AS employee_count
FROM Department d
LEFT JOIN Employee_Department ed ON d.department_id = ed.department_id
GROUP BY d.department_name;

-- mức lương cao nhất theo từng bộ phận-- \
SELECT d.department_name, e.name, ed.salary
FROM Employee_Department ed
JOIN Employee e ON ed.employee_id = e.employee_id
JOIN Department d ON ed.department_id = d.department_id
WHERE ed.salary = (
    SELECT MAX(ed2.salary)
    FROM Employee_Department ed2
    WHERE ed2.department_id = ed.department_id
);

-- mức lương của nhân viên vượt quá 100,000-- 
SELECT d.department_name, SUM(ed.salary) AS total_salary
FROM Department d
JOIN Employee_Department ed ON d.department_id = ed.department_id
GROUP BY d.department_name
HAVING total_salary > 100000;


