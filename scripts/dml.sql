-- Pregunta #1: ¿Cuáles son los 10 clientes que generan mayor revenue total?
-- Top 10 clientes por revenue total --

SELECT TOP 10
    c.customer_id,
    c.customer_name,
    c.customer_type,
    SUM(l.revenue) AS Total_Revenue
FROM loads l
JOIN customers c ON l.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type
ORDER BY Total_Revenue DESC;

--Pregunta #2: ¿Cuántos loads tiene cada cliente, y cuántos se encuentran en estado "Completed" frente a otros estados?
SELECT TOP 20
    c.customer_id,
    c.customer_name,
    COUNT(l.load_id) AS Total_Loads,
    SUM(CASE WHEN l.load_status = 'Completed' THEN 1 ELSE 0 END) AS Loads_Completados,
    ROUND(
        SUM(CASE WHEN l.load_status = 'Completed' THEN 1.0 ELSE 0 END) * 100.0 / COUNT(l.load_id), 
    2) AS Pct_Completados
FROM loads l
JOIN customers c ON l.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY Total_Loads DESC;


--Pregunta #3: ¿Qué clientes tienen la cuenta marcada como "Inactive" pero registran cargas recientes?
SELECT TOP 15
    c.customer_id,
    c.customer_name,
    c.account_status,
    COUNT(l.load_id) AS Total_Loads,
    MAX(l.load_date) AS Ultima_Carga
FROM customers c
JOIN loads l ON c.customer_id = l.customer_id
WHERE c.account_status = 'Inactive'
GROUP BY c.customer_id, c.customer_name, c.account_status
ORDER BY Ultima_Carga DESC;

--Pregunta #4: ¿Cuál es el revenue promedio por tipo de cliente (Dedicated, Contract, Spot)?
SELECT TOP 18
    c.customer_type,
    COUNT(l.load_id) AS Total_Loads,
    ROUND(AVG(l.revenue), 2) AS Revenue_Promedio,
    ROUND(SUM(l.revenue), 2) AS Revenue_Total
FROM loads l
JOIN customers c ON l.customer_id = c.customer_id
GROUP BY c.customer_type
ORDER BY Revenue_Promedio DESC;

--Pregunta #5: ¿Qué clientes tienen un potencial de ingreso anual alto pero un revenue real bajo, evidenciando una brecha no capturada?
SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_type,
    c.annual_revenue_potential,
    ROUND(SUM(l.revenue), 2) AS Revenue_Real,
    ROUND(c.annual_revenue_potential - SUM(l.revenue), 2) AS Brecha,
    ROUND((c.annual_revenue_potential - SUM(l.revenue)) * 100.0 / c.annual_revenue_potential, 2) AS Pct_Brecha
FROM customers c
JOIN loads l ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type, c.annual_revenue_potential
ORDER BY Brecha DESC;

--Pregunta #6:Revenue mensual por cliente --

SELECT 
    c.customer_id,
    c.customer_name,
    FORMAT(l.load_date, 'yyyy-MM') AS Mes,
    ROUND(SUM(l.revenue), 2) AS Revenue_Mensual
FROM loads l
JOIN customers c ON l.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, FORMAT(l.load_date, 'yyyy-MM')
ORDER BY c.customer_id, Mes;


--Pregunta #7: Ranking de clientes por revenue dentro de cada tipo de carga --
SELECT 
    c.customer_id,
    c.customer_name,
    c.primary_freight_type,
    ROUND(SUM(l.revenue), 2) AS Revenue_Total,
    RANK() OVER (PARTITION BY c.primary_freight_type ORDER BY SUM(l.revenue) DESC) AS Ranking
FROM loads l
JOIN customers c ON l.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.primary_freight_type
ORDER BY c.primary_freight_type, Ranking;


--Pregunta #8: Participación porcentual de cada cliente sobre el revenue total --

SELECT 
    c.customer_id,
    c.customer_name,
    ROUND(SUM(l.revenue), 2) AS Revenue_Cliente,
    ROUND(SUM(SUM(l.revenue)) OVER (), 2) AS Revenue_Total_Cartera,
    ROUND(SUM(l.revenue) * 100.0 / SUM(SUM(l.revenue)) OVER (), 2) AS Pct_Participacion
FROM loads l
JOIN customers c ON l.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY Pct_Participacion DESC;



--Pregunta #9: Tasa de crecimiento mensual de revenue por cliente --

SELECT 
    c.customer_id,
    c.customer_name,
    FORMAT(l.load_date, 'yyyy-MM') AS Mes,
    ROUND(SUM(l.revenue), 2) AS Revenue_Mensual,
    ROUND(
        LAG(SUM(l.revenue)) OVER (PARTITION BY c.customer_id ORDER BY FORMAT(l.load_date, 'yyyy-MM')), 
    2) AS Revenue_Mes_Anterior,
    ROUND(
        (SUM(l.revenue) - LAG(SUM(l.revenue)) OVER (PARTITION BY c.customer_id ORDER BY FORMAT(l.load_date, 'yyyy-MM'))) 
        * 100.0 / LAG(SUM(l.revenue)) OVER (PARTITION BY c.customer_id ORDER BY FORMAT(l.load_date, 'yyyy-MM')), 
    2) AS Pct_Crecimiento
FROM loads l
JOIN customers c ON l.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, FORMAT(l.load_date, 'yyyy-MM')
ORDER BY c.customer_id, Mes;


--Pregunta #10: Distribución de booking_type por cliente --

SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(l.load_id) AS Total_Loads,
    SUM(CASE WHEN l.booking_type = 'Spot' THEN 1 ELSE 0 END) AS Loads_Spot,
    SUM(CASE WHEN l.booking_type = 'Dedicated' THEN 1 ELSE 0 END) AS Loads_Dedicated,
    ROUND(
        SUM(CASE WHEN l.booking_type = 'Spot' THEN 1.0 ELSE 0 END) * 100.0 / COUNT(l.load_id), 
    2) AS Pct_Spot
FROM loads l
JOIN customers c ON l.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY Pct_Spot DESC;