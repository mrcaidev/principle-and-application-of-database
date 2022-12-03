-- 查询所有房型的具体信息，包括房型编号、房型名称、酒店编号。
SELECT *
FROM room_type;

-- 查询所有酒店名称中包含“希尔顿”的酒店，返回酒店名称、酒店编号。
SELECT *
FROM hotel
WHERE hotel_name LIKE '%希尔顿%';

-- 查询订单总价在 10000 元及以上的所有订单详情，包括订单编号、酒店编号、房型编号及居住时长。
SELECT hotel_order.order_id,
    hotel.hotel_id,
    hotel_order.room_id,
    (hotel_order.leave_date - hotel_order.start_date) AS period
FROM hotel_order
    LEFT OUTER JOIN room_type ON room_type.room_id = hotel_order.room_id
    LEFT OUTER JOIN hotel ON hotel.hotel_id = room_type.hotel_id
WHERE hotel_order.payment >= 10000;

-- 查询所有房型的订单情况，包括房型编号、房型名称、订单编号、价格。
SELECT hotel_order.room_id,
    room_type.room_name,
    hotel_order.order_id,
    hotel_order.payment
FROM hotel_order
    LEFT OUTER JOIN room_type ON room_type.room_id = hotel_order.room_id;

-- 创建启悦酒店的订单视图。
CREATE OR REPLACE VIEW qiyue_hotel AS
SELECT hotel_order.*
FROM hotel_order
    LEFT OUTER JOIN room_type ON room_type.room_id = hotel_order.room_id
    LEFT OUTER JOIN hotel ON hotel.hotel_id = room_type.hotel_id
WHERE hotel.hotel_name = '启悦酒店';

-- 在订单表的总价字段上创建降序的普通索引。索引名为 order_payment. 用 \di 命令查看创建的索引。
CREATE INDEX order_payment ON hotel_order(payment DESC);

-- 创建函数：查询给定日期，给定酒店所有房型的平均价格。执行函数，输入参数为 2020-11-14，希尔顿大酒店。
CREATE OR REPLACE FUNCTION get_average_price_on_date_hotel(DATE, VARCHAR(255))
RETURNS DECIMAL(10, 2)
AS $$
    DECLARE average_price DECIMAL(10, 2);

    BEGIN
        SELECT AVG(room_info.price) INTO average_price
        FROM room_info
            LEFT OUTER JOIN room_type ON room_type.room_id = room_info.room_id
            LEFT OUTER JOIN hotel ON hotel.hotel_id = room_type.hotel_id
        WHERE room_info.date = $1
            AND hotel.hotel_name = $2;
        RETURN average_price;
    END
$$ LANGUAGE plpgsql;

SELECT get_average_price_on_date_hotel('2020-11-14', '希尔顿大酒店') AS avg_price;

-- 创建存储过程：从订单表中统计指定酒店、指定日期的各种房型的预订情况，返回酒店名称、房型编号、房型名称、预定数量。
-- 执行存储过程：统计希尔顿大酒店 2020-11-14 当天各个房型预订情况。
CREATE OR REPLACE PROCEDURE get_room_type_order_on_date_hotel(DATE, VARCHAR(255))
AS
    CURSOR c IS
        SELECT FIRST(hotel.hotel_name) AS hotel_name,
            hotel_order.room_id,
            FIRST(room_type.room_name) AS room_name,
            SUM(hotel_order.amount) AS amount
        FROM hotel_order
            LEFT OUTER JOIN room_type ON room_type.room_id = hotel_order.room_id
            LEFT OUTER JOIN hotel ON hotel.hotel_id = room_type.hotel_id
        WHERE hotel_order.create_date = $1
            AND hotel.hotel_name = $2
        GROUP BY hotel_order.room_id;

    hotel_name VARCHAR(255);
    room_id INT;
    room_name VARCHAR(255);
    amount INT;

    BEGIN
        OPEN c;
        LOOP
            FETCH c INTO hotel_name, room_id, room_name, amount;
            EXIT WHEN c%notfound;
            RAISE INFO 'hotel_name: %', hotel_name;
            RAISE INFO 'room_id:    %', room_id;
            RAISE INFO 'room_name:  %', room_name;
            RAISE INFO 'amount:     %', amount;
            RAISE INFO '';
        END LOOP;
        CLOSE c;
    END
;

CALL get_room_type_order_on_date_hotel('2020-11-14', '希尔顿大酒店');

-- 查找同时评价了 2 次及以上的用户信息。
SELECT *
FROM customer
WHERE uid IN (
    SELECT uid
    FROM rating
    GROUP BY uid
    HAVING COUNT(*) >= 2
);

-- 查询评价过所有总统套房的顾客姓名。
SELECT customer.uname
FROM customer
WHERE customer.uid IN (
    SELECT uid
    FROM customer
    WHERE NOT EXISTS (
        SELECT *
        FROM room_type
            LEFT OUTER JOIN hotel_order ON hotel_order.room_id = room_type.room_id
        WHERE room_type.room_name = '总统套房'
            AND NOT EXISTS (
                SELECT *
                FROM rating
                WHERE rating.uid = customer.uid
                    AND rating.order_id = hotel_order.order_id
            )
    )
);

-- 若要预订 11.14-16 日每天房间数量 4 间。
-- 查询满足条件（时间区间，将预订房间数）的房型及其平均价格，并按平均价格从低到高进行排序。
-- 查询结果应包含酒店、房型及平均价格信息。
SELECT FIRST(hotel.hotel_name) AS hotel_name,
    FIRST(room_type.room_name) AS room_name,
    AVG(room_info.price) AS average_price
FROM room_info
    LEFT OUTER JOIN room_type ON room_type.room_id = room_info.room_id
    LEFT OUTER JOIN hotel ON hotel.hotel_id = room_type.hotel_id
WHERE room_info.room_id IN (
    SELECT room_id
    FROM room_info
    WHERE room_id IN (
        SELECT room_id
        FROM room_info
        WHERE DATE = '2020-11-14'
            AND remain >= 4
    )
    INTERSECT
    (
        SELECT room_id
        FROM room_info
        WHERE DATE = '2020-11-15'
            AND remain >= 4
    )
    INTERSECT
    (
        SELECT room_id
        FROM room_info
        WHERE DATE = '2020-11-16'
            AND remain >= 4
    )
)
GROUP BY room_info.room_id;

-- 编写触发器：完成预订房间，包括创建订单和更新房型信息。
-- 该订单为预订 11 月 14 号-15 号 4 号房型 4 间。

-- 创建订单的存储过程。
CREATE OR REPLACE PROCEDURE order_room(t_start_date DATE, t_leave_date DATE, t_room_id INT, t_amount INT, t_customer_id INT)
AS
    BEGIN
        INSERT INTO hotel_order
        VALUES (
            (
                SELECT MAX(order_id) + 1
                FROM hotel_order
            ),
            t_room_id,
            t_start_date,
            t_leave_date,
            t_amount,
            (
                SELECT SUM(price) * t_amount
                FROM room_info
                WHERE room_id = t_room_id
                    AND date IN (
                        SELECT a
                        FROM generate_series(
                            t_start_date::DATE,
                            t_leave_date::DATE,
                            '1 day'
                        ) s(a)
                    )
            ),
            NOW(),
            t_customer_id
        );
    END
;

-- 在创建订单前，要检查房间余量是否充足。
CREATE OR REPLACE FUNCTION check_remain()
RETURNS TRIGGER
AS $$
    DECLARE total_count INT;
    DECLARE available_count INT;

    BEGIN
        SELECT COUNT(*) INTO total_count
        FROM room_info
        WHERE room_id = new.room_id
            AND date IN (
                SELECT a
                FROM generate_series(
                    new.start_date::DATE,
                    new.leave_date::DATE,
                    '1 day'
                ) s(a)
            );
        SELECT COUNT(*) INTO available_count
        FROM room_info
        WHERE room_id = new.room_id
            AND date IN (
                SELECT a
                FROM generate_series(
                    new.start_date::DATE,
                    new.leave_date::DATE,
                    '1 day'
                ) s(a)
            )
            AND remain >= new.amount;

        IF available_count < total_count THEN
            RAISE EXCEPTION 'Not enough rooms';
        END IF;

        RETURN new;
    END
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_remain_trigger ON hotel_order;
CREATE TRIGGER check_remain_trigger
BEFORE INSERT ON hotel_order
FOR EACH ROW
EXECUTE PROCEDURE check_remain();

-- 在创建订单后，要减少房间余量。
CREATE OR REPLACE FUNCTION update_remain()
RETURNS TRIGGER
AS $$
    DECLARE CURSOR c IS
        SELECT info_id, remain
        FROM room_info
        WHERE room_id = new.room_id
            AND date IN (
                SELECT a
                FROM generate_series(
                    new.start_date::DATE,
                    new.leave_date::DATE,
                    '1 day'
                ) s(a)
            );

    DECLARE t_info_id INT;
    DECLARE now_remain INT;

    BEGIN
        OPEN c;
        LOOP
            FETCH c INTO t_info_id, now_remain;
            EXIT WHEN c%notfound;

            UPDATE room_info
            SET remain = now_remain - new.amount
            WHERE info_id = t_info_id;
        END LOOP;
        CLOSE c;
        RETURN new;
    END
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_remain_trigger ON hotel_order;
CREATE TRIGGER update_remain_trigger
AFTER INSERT ON hotel_order
FOR EACH ROW
EXECUTE PROCEDURE update_remain();

CALL order_room('2020-11-14', '2020-11-15', 4, 10, 2019018);
