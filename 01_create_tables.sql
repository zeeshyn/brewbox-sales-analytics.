CREATE TABLE customers(
	customer_id INT PRIMARY KEY,
	customer_name TEXT,
    city          TEXT,
    signup_date   DATE
);

CREATE TABLE products(
product_id INT PRIMARY KEY,
    product_name  TEXT,
    category      TEXT,
    cost_price    NUMERIC(10,2),
    selling_price NUMERIC(10,2)
);



CREATE TABLE orders (
    order_id       INT PRIMARY KEY,
    customer_id    INT REFERENCES customers(customer_id),
    order_date     DATE,
    channel        TEXT,
    payment_method TEXT,
    discount_pct   INT,
    order_status   TEXT
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id      INT REFERENCES orders(order_id),
    product_id    INT REFERENCES products(product_id),
    quantity      INT,
    unit_price    NUMERIC(10,2)
);




