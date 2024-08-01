/*# Exercícios de MySQL

## Estrutura do Banco de dados

Este diagrama exemplifica como funciona a estrutura do banco de dados, poderá servir de guia para o desenvolvimento das atividades.

```mermaid
erDiagram
    CLIENTS {
        int id PK "Auto Increment"
        string name
        string email
    }

    ORDERS {
        int id PK "Auto Increment"
        int client_id FK
        date order_date
        decimal total
    }

    PRODUCTS {
        int id PK "Auto Increment"
        string name
        decimal price
    }

    ORDER_ITEMS {
        int order_id PK, FK
        int product_id PK, FK
        int quantity
        decimal price
    }

    CLIENTS ||--o{ ORDERS : faz
    ORDERS ||--|{ ORDER_ITEMS : contem
    PRODUCTS ||--|{ ORDER_ITEMS : contem
```*/

create database startup;
use startup;

/*## Exercício 1 - Fácil

1. Crie a tabela `CLIENTS` com as seguintes colunas:

    - `id`: inteiro, chave primária, auto incrementável
    - `name`: texto, não nulo
    - `email`: texto, não nulo*/

CREATE TABLE clients (
    client_id INT PRIMARY KEY auto_increment,
    name VARCHAR(50) not null,
    email varchar(50) not null
);

/*## Exercício 2 - Fácil

2. Crie a tabela `PRODUCTS` com as seguintes colunas:
    - `id`: inteiro, chave primária, auto incrementável
    - `name`: texto, não nulo
    - `price`: decimal, não nulo*/

CREATE TABLE products (
    product_id INT PRIMARY KEY auto_increment,
    name varchar(50) not null,
    price decimal(10,2) not null
);

/*## Exercício 3 - Médio

3. Crie a tabela `ORDERS` com as seguintes colunas:
    - `id`: inteiro, chave primária, auto incrementável
    - `client_id`: inteiro, chave estrangeira referenciando `CLIENTS(id)`
    - `order_date`: data, não nulo
    - `total`: decimal, não nulo*/

CREATE TABLE orders (
    id INT PRIMARY KEY auto_increment,
    client_id int,
    order_date date not null,
    total decimal(10,2) not null,
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

/*## Exercício 4 - Médio

4. Crie a tabela `ORDER_ITEMS` com as seguintes colunas:
    - `order_id`: inteiro, chave estrangeira referenciando `ORDERS(id)`
    - `product_id`: inteiro, chave estrangeira referenciando `PRODUCTS(id)`
    - `quantity`: inteiro, não nulo
    - `price`: decimal, não nulo*/
    
CREATE TABLE order_items (
    order_id INT ,
    product_id int,
    quantity int not null,
    price decimal(10,2) not null,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

/*## Exercício 5 - Fácil

5. Insira dados nas tabelas `CLIENTS` e `PRODUCTS`.*/

INSERT INTO clients (client_id, name, email) VALUES
(1, 'Ana', 'ana@' ),
(2, 'Bruno', 'bruno@' ),
(3, 'Carlos', 'carlos@'),
(4, 'Luiz','luiz@'  ),
(5, 'Letícia', 'leticia@');

INSERT INTO products (product_id, name, price) VALUES
( 101, 'Livro', 20.00),
( 102, 'Caneta', 2.50),
( 103, 'Caderno', 10.00),
( 104, 'borracha', 1.50),
( 105, 'lápis', 3.00);

/*## Exercício 6 - Médio

6. Insira dados na tabela `ORDERS`.*/

INSERT INTO orders (id, client_id, order_date, total) VALUES
( 201, 1, '2024-07-08', 40.00),
( 202, 2, '2024-05-16', 70.00),
( 203, 3, '2024-09-11', 25.00),
( 204, 4, '2024-12-23', 80.00),
( 205, 5, '2024-03-10', 90.00);

/*## Exercício 7 - Médio

7. Insira dados na tabela `ORDER_ITEMS`.*/

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
( 201, 101, 40, 30.00),
( 202, 102, 70, 70.00),
( 203, 103, 50, 20.00),
( 204, 104, 20, 50.00),
( 205, 105, 90, 90.00);


/*## Exercício 8 - Difícil

8. Atualize o preço de um produto na tabela `PRODUCTS` e todos os registros relacionados na tabela `ORDER_ITEMS`.*/

UPDATE products
SET price = 50
WHERE product_id = 103;

UPDATE order_items
SET price = 90
WHERE product_id = 103;

/*## Exercício 9 - Fácil

9. Delete um cliente e todos os pedidos relacionados.*/

delete from order_items
where order_id = 203;

delete from orders
where client_id = 3;

DELETE FROM clients
WHERE client_id = 3;

/*## Exercício 10 - Médio

10. Altere a tabela `CLIENTS` para adicionar uma coluna de data de nascimento (`birthdate`).*/

ALTER TABLE clients
ADD birthdate DATE;

/*## Exercício 11 - Médio

11. Faça uma consulta usando JOIN para listar todos os pedidos com os nomes dos clientes e os nomes dos produtos.*/

SELECT orders.id AS order_id, clients.name AS client_name, products.name AS product_name
FROM orders 
inner JOIN clients  ON orders.client_id = clients.client_id
inner JOIN order_items  ON orders.id = order_items.order_id
inner JOIN products  ON order_items.product_id = products.product_id;


/*## Exercício 12 - Difícil

12. Faça uma consulta usando LEFT JOIN para listar todos os clientes e seus pedidos, incluindo clientes sem pedidos.*/

SELECT clients.name AS client_name, orders.id AS order_id
FROM clients 
LEFT JOIN orders  ON clients.client_id = orders.client_id;


/*## Exercício 13 - Difícil

13. Faça uma consulta usando RIGHT JOIN para listar todos os produtos e os pedidos que os contêm, incluindo produtos que não foram pedidos.*/

SELECT products.name AS product_name, orders.id AS order_id
FROM products 
RIGHT JOIN order_items ON products.product_id = order_items.product_id
RIGHT JOIN orders ON order_items.order_id = orders.id;

/*## Exercício 14 - Médio

14. Utilize funções de agregação para obter o total de vendas e a quantidade total de itens vendidos.*/

SELECT SUM(total) AS total_vendas
FROM orders;

SELECT SUM(quantity) AS total_itens_vendidos
FROM order_items;

/*## Exercício 15 - Médio

15. Faça uma consulta para listar todos os clientes e a quantidade total de pedidos realizados por cada um, ordenados pela quantidade de pedidos em ordem decrescente.*/

SELECT clients.name AS client_name, COUNT(orders.id) AS total_pedidos
FROM clients 
LEFT JOIN orders  ON clients.client_id = orders.client_id
GROUP BY clients.client_id
ORDER BY total_pedidos DESC;

/*## Exercício 16 - Médio

16. Faça uma consulta para listar todos os produtos e a quantidade total de cada produto vendido, ordenados pela quantidade em ordem decrescente.*/

SELECT products.name AS product_name, SUM(order_items.quantity) AS total_vendido
FROM products 
LEFT JOIN order_items  ON products.product_id = order_items.product_id
GROUP BY products.product_id
ORDER BY total_vendido DESC;

/*## Exercício 17 - Médio

17. Faça uma consulta para listar todos os clientes e o valor total gasto por cada um, ordenados pelo valor gasto em ordem decrescente.*/

SELECT clients.name AS client_name, SUM(orders.total) AS total_spent
FROM clients 
JOIN orders  ON clients.client_id = orders.client_id
GROUP BY clients.client_id
ORDER BY total_spent DESC;

/*## Exercício 18 - Difícil

18. Faça uma consulta para listar os 3 produtos mais vendidos (em quantidade) e o total de vendas de cada um.*/

SELECT products.name AS product_name, SUM(order_items.quantity) AS total_sold
FROM products 
JOIN order_items ON products.product_id = order_items.product_id
GROUP BY products.product_id
ORDER BY total_sold DESC
LIMIT 3;

/*## Exercício 19 - Difícil

19. Faça uma consulta para listar os 3 clientes que mais gastaram e o total gasto por cada um.*/

SELECT clients.name AS client_name, SUM(orders.total) AS total_spent
FROM clients 
JOIN orders  ON clients.client_id = orders.client_id
GROUP BY clients.client_id
ORDER BY total_spent DESC
LIMIT 3;

/*## Exercício 20 - Médio

20. Faça uma consulta para listar a média de quantidade de produtos por pedido para cada cliente.*/

SELECT clients.name AS client_name, AVG(order_items.quantity) AS avg_products_per_order
FROM clients 
JOIN orders  ON clients.client_id = orders.client_id
JOIN order_items ON orders.id = order_items.order_id
GROUP BY clients.client_id;

/*## Exercício 21 - Médio

21. Faça uma consulta para listar o total de pedidos e o total de clientes por mês.*/

SELECT EXTRACT(MONTH FROM order_date) AS month, 
       COUNT(DISTINCT orders.id) AS total_orders,
       COUNT(DISTINCT clients.client_id) AS total_clients
FROM orders 
JOIN clients  ON orders.client_id = clients.client_id
GROUP BY month;

/*## Exercício 22 - Difícil

22. Faça uma consulta para listar os produtos que nunca foram vendidos.*/

SELECT products.name AS product_name
FROM products 
LEFT JOIN order_items  ON products.product_id = order_items.product_id
WHERE order_items.product_id IS NULL;

/*## Exercício 23 - Médio

23. Faça uma consulta para listar os pedidos que contêm mais de 2 itens diferentes.*/

SELECT orders.id AS order_id
FROM orders 
inner JOIN order_items  ON orders.id = order_items.order_id
GROUP BY orders.id
HAVING COUNT(DISTINCT order_items.product_id) > 2;

/*## Exercício 24 - Médio

24. Faça uma consulta para listar os clientes que fizeram pedidos no último mês.*/

SELECT clients.name AS client_name
FROM clients 
JOIN orders  ON clients.client_id = orders.client_id
WHERE orders.order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH);

/*## Exercício 25 - Difícil

25. Faça uma consulta para listar os clientes com o maior valor médio por pedido.*/

SELECT clients.name AS client_name, AVG(orders.total) AS avg_order_value
FROM clients 
JOIN orders ON clients.client_id = orders.client_id
GROUP BY clients.client_id
ORDER BY avg_order_value DESC;
