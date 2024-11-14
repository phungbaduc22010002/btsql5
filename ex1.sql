USE `buoi6`;

ALTER TABLE `building`
ADD CONSTRAINT `fk_building_host`
FOREIGN KEY (`host_id`) REFERENCES `host`(`id`);

ALTER TABLE `building`
ADD CONSTRAINT `fk_building_contractor`
FOREIGN KEY (`contractor_id`) REFERENCES `contractor`(`id`);

ALTER TABLE `design`
ADD CONSTRAINT `fk_design_building`
FOREIGN KEY (`building_id`) REFERENCES `building`(`id`);

ALTER TABLE `design`
ADD CONSTRAINT `fk_design_architect`
FOREIGN KEY (`architect_id`) REFERENCES `architect`(`id`);

ALTER TABLE `work`
ADD CONSTRAINT `fk_work_building`
FOREIGN KEY (`building_id`) REFERENCES `building`(`id`);

ALTER TABLE `work`
ADD CONSTRAINT `fk_work_worker`
FOREIGN KEY (`worker_id`) REFERENCES `worker`(`id`);


-- Hiển thị thông tin công trình có chi phí cao nhất-- 
SELECT * FROM `building` 
ORDER BY `cost` DESC
LIMIT 1;
-- Hiển thị thông tin công trình có chi phí lớn hơn tất cả các công trình được xây dựng ở Cần Thơ-- -- 
SELECT * FROM `building`
WHERE `cost` > ALL (
    SELECT `cost` 
    FROM `building`
    WHERE `city` = 'can tho'
);

-- Hiển thị thông tin công trình có chi phí lớn hơn một trong các công trình được xây dựng ở Cần Thơ-- 
SELECT * FROM `building`
WHERE `cost` > ANY (
    SELECT `cost` 
    FROM `building`
    WHERE `city` = 'can tho'
);

-- Hiển thị thông tin công trình chưa có kiến trúc sư thiết kến-- 
SELECT * FROM `building`
WHERE `id` NOT IN (
    SELECT `building_id` 
    FROM `design`
);

 -- thông tin các kiến trúc sư cùng năm sinh và cùng nơi tốt nghiệp-- 
SELECT * FROM `architect` AS a1
JOIN `architect` AS a2
ON a1.`birthday` = a2.`birthday`
AND a1.`place` = a2.`place`
AND a1.`id` < a2.`id`;

-- ex4-- 

SELECT 
architect_id,
AVG(benefit) AS  trung_binh
FROM design
 GROUP BY architect_id;
 
 
 SELECT SUM(cost),
 city AS thanh_pho
  FROM building
  GROUP BY city;
 
-- ex5 --



SELECT building.name AS Cong_Trinh, host.name AS Chu_Nhan, contractor.name AS Chu_Thau
FROM building
JOIN host ON building.host_id = host.id
JOIN contractor ON building.contractor_id = contractor.id;


SELECT building.name AS Cong_Trinh, architect.name AS Kien_Truc_Su, design.benefit AS Thu_Lao
FROM design
JOIN building ON design.building_id = building.id
JOIN architect ON design.architect_id = architect.id;


SELECT building.name AS Cong_Trinh, building.address AS dc_cong_trinh
FROM building
JOIN contractor ON building.contractor_id = contractor.id
WHERE contractor.name = 'cty xd so 6';

SELECT worker.name AS Ten_congnhan, worker.birthday AS nam_sinh, worker.year AS nam_vaonghe
FROM worker
JOIN work ON worker.id = work.worker_id
JOIN building ON work.building_id = building.id
JOIN contractor ON building.contractor_id = contractor.id
WHERE contractor.name ='le van son'
AND (worker.skill='han' 
OR worker.skill='dien');

-- Công nhân tham gia công trình Khách sạn Quốc Tế ở Cần Thơ-- 

SELECT worker.name, work.total 
FROM work
JOIN worker ON work.worker_id = worker.id
JOIN building ON work.building_id = building.id
WHERE building.name = 'khach san quoc te' 
AND building.city = 'can tho'
AND work.date BETWEEN '1994-12-15' AND '1994-12-31';

-- Kiến trúc sư tốt nghiệp ở TP Hồ Chí Minh và thiết kế công trình có kinh phí trên 400 triệu đồng-- 
SELECT architect.name, architect.birthday
FROM architect
JOIN design ON architect.id = design.architect_id
JOIN building ON design.building_id = building.id
WHERE architect.place = 'tp hcm' 
AND building.cost > 400;

-- Tên các kiến trúc sư thiết kế công trình của Phòng dịch vụ sở xây dựng và của Lê Văn Sơn1-- 
SELECT DISTINCT a.name
FROM architect a
JOIN design d ON a.id = d.architect_id
JOIN building b1 ON d.building_id = b1.id
JOIN contractor c1 ON b1.contractor_id = c1.id
WHERE c1.name = 'phong dich vu so xd'
AND a.id IN (
    SELECT a2.id
    FROM architect a2
    JOIN design d2 ON a2.id = d2.architect_id
    JOIN building b2 ON d2.building_id = b2.id
    JOIN contractor c2 ON b2.contractor_id = c2.id
    WHERE c2.name = 'le van son'
);
-- Công nhân tham gia các công trình ở Cần Thơ nhưng không tham gia công trình ở Vĩnh Long-- 
SELECT DISTINCT worker.name 
FROM worker
JOIN work ON worker.id = work.worker_id
JOIN building ON work.building_id = building.id
WHERE building.city = 'can tho'
AND worker.id NOT IN (
    SELECT worker.id
    FROM worker
    JOIN work ON worker.id = work.worker_id
    JOIN building ON work.building_id = building.id
    WHERE building.city = 'vinh long'
);


-- Tên chủ thầu thi công công trình có kinh phí lớn hơn tất cả công trình của Phòng dịch vụ sở xây dựng-- 

SELECT DISTINCT contractor.name
FROM contractor
JOIN building ON contractor.id = building.contractor_id
WHERE building.cost > (
    SELECT MAX(cost)
    FROM building
    JOIN contractor ON building.contractor_id = contractor.id
    WHERE contractor.name = 'phong dich vu so xd'
);

-- Kiến trúc sư có thù lao thiết kế công trình dưới giá trị trung bình-- 
SELECT architect.name
FROM architect
JOIN design ON architect.id = design.architect_id
WHERE design.benefit < (
    SELECT AVG(benefit)
    FROM design
);

-- 1Chủ thầu trúng thầu công trình có kinh phí thấp nhất-- 
SELECT contractor.name, contractor.address
FROM contractor
JOIN building ON contractor.id = building.contractor_id
WHERE building.cost = (
    SELECT MIN(cost)
    FROM building
);

-- Công nhân tham gia công trình do kiến trúc sư Lê Thanh Tùng thiết kế-- 
SELECT worker.name, worker.skill
FROM worker
JOIN work ON worker.id = work.worker_id
JOIN building ON work.building_id = building.id
JOIN design ON building.id = design.building_id
JOIN architect ON design.architect_id = architect.id
WHERE architect.name = 'le thanh tung';

-- Cặp tên của chủ thầu trúng thầu công trình tại cùng một thành phố-- 
SELECT DISTINCT c1.name AS contractor1, c2.name AS contractor2
FROM building b1
JOIN contractor c1 ON b1.contractor_id = c1.id
JOIN building b2 ON b1.city = b2.city
JOIN contractor c2 ON b2.contractor_id = c2.id
WHERE c1.id < c2.id;

-- Tổng kinh phí của tất cả các công trình theo từng chủ thầu:-- 
SELECT contractor.name, SUM(building.cost) AS total_cost
FROM contractor
JOIN building ON contractor.id = building.contractor_id
GROUP BY contractor.name;

-- Kiến trúc sư có tổng thù lao thiết kế các công trình lớn hơn 25 triệu-- 
SELECT architect.name
FROM architect
JOIN design ON architect.id = design.architect_id
GROUP BY architect.name
HAVING SUM(design.benefit) > 25;


-- Công nhân tham gia ở tất cả các công trình-- 

SELECT worker.name
FROM worker
JOIN work ON worker.id = work.worker_id
GROUP BY worker.id
HAVING COUNT(DISTINCT work.building_id) = (SELECT COUNT(DISTINCT building.id) FROM building);
