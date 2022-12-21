-- Supplier "Booker Transmission" has been found to have produced
-- a defective batch of conveyer belts (a component)
-- between 2021-06-01 and 2021-07-01.
-- Find the VINs of each car that has one of these belts installed,
-- and the customer to whom it was sold.
SELECT transaction.car_id "vin", customer.name "customer"
FROM customer
    LEFT OUTER JOIN transaction ON transaction.customer_id = customer.id
    LEFT OUTER JOIN component ON component.car_id = transaction.car_id
    LEFT OUTER JOIN supplier ON supplier.id = component.supplier_id
WHERE supplier.name = 'Booker Transmission'
    AND component.name = 'conveyer belt'
    AND component.created_at > '2021-06-01'
    AND component.created_at < '2021-07-01';

-- Find the top two brands by total sales in the past year.
SELECT brand.name, SUM(transaction.cost) "sales"
FROM brand
    LEFT OUTER JOIN model ON model.brand_id = brand.id
    LEFT OUTER JOIN car ON car.model_id = model.id
    LEFT OUTER JOIN transaction ON transaction.car_id = car.id
WHERE transaction.date > NOW() - INTERVAL '1 YEAR'
GROUP BY brand.name
ORDER BY SUM(transaction.cost) DESC
LIMIT 2;

-- Find the top two brands by average sales in the past year.
SELECT brand.name, AVG(transaction.cost) "sales"
FROM brand
    LEFT OUTER JOIN model ON model.brand_id = brand.id
    LEFT OUTER JOIN car ON car.model_id = model.id
    LEFT OUTER JOIN transaction ON transaction.car_id = car.id
WHERE transaction.date > NOW() - INTERVAL '1 YEAR'
GROUP BY brand.name
ORDER BY AVG(transaction.cost) DESC
LIMIT 2;

-- Which month was the best for sales of Express?
SELECT EXTRACT(MONTH FROM transaction.date) "month", SUM(transaction.cost) "sales"
FROM transaction
    LEFT OUTER JOIN car ON car.id = transaction.car_id
    LEFT OUTER JOIN model ON model.id = car.model_id
    LEFT OUTER JOIN brand ON brand.id = model.brand_id
WHERE model.name = 'Express'
GROUP BY EXTRACT(MONTH FROM transaction.date)
ORDER BY SUM(transaction.cost) DESC
LIMIT 1;
