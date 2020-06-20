/* Procedure that adds the item order into the ItemOrder Table */
CREATE OR REPLACE PROCEDURE addItemOrder(ordId in ItemOrder.orderId%type, iId in ItemOrder.ItemId%type,
cId in ItemOrder.CustId%type, ordDate in ItemOrder.OrderDate%type, numItems in ItemOrder.noOfItems%type, 
shipDate in ItemOrder.ShippedDate%type)
IS
    l_custType Customers.CustType%type;
    l_copies ComicBooks.Copies%type;
    l_shippingFee ItemOrder.ShippingFee%type;
BEGIN
    SELECT Copies INTO l_copies FROM ComicBooks WHERE ItemId = iId;
    SELECT CustType INTO l_custType FROM Customers WHERE CustId = cId;

    --constraint: when a regular customer orders, the shipping fee is 10, if the custType changes to 'gold', the shipping fee is 0
    IF (l_custType = 'regular') THEN
	l_shippingFee := 10.00;
    ELSIF (l_custType = 'gold') THEN
	l_shippingFee := 0.00;
    END IF;
    
    --constraint: number of copies of any book cannot be more than the available number of copies of that book 
    IF(l_copies >= numItems) THEN
	INSERT INTO ItemOrder VALUES(ordId, iId, cId, ordDate, numItems, NULL, l_shippingFee);
	UPDATE ComicBooks SET Copies = l_copies - numItems WHERE ItemId = iId;
    ELSE
	DBMS_OUTPUT.PUT_LINE('We dont have enough books for your order');
    END IF;
EXCEPTION
    --needed because the SELECT INTO for Tshirts will return "no data found"
    WHEN NO_DATA_FOUND THEN
    DECLARE
	l_custType Customers.CustType%type;
	l_shippingFee ItemOrder.ShippingFee%type;
    BEGIN
	SELECT CustType INTO l_custType FROM Customers WHERE CustId = cId;
	IF (l_custType = 'regular') THEN
	    l_shippingFee := 10.00;
	ELSIF (l_custType = 'gold') THEN
	    l_shippingFee := 0.00;
	END IF;

	INSERT INTO ItemOrder VALUES(ordId, iId, cId, ordDate, numItems, NULL, l_shippingFee);
    END;
END;
/
Show Errors;

/* Trigger that updates the shipping fee based on updates to the customer type */
--constraint: when a regular customer orders, the shipping fee is 10, if the custType changes to 'gold', the shipping fee is 0
CREATE OR REPLACE TRIGGER changeCustType_trig
AFTER UPDATE ON Customers
FOR EACH ROW
BEGIN
    IF :new.custType = 'gold' THEN
	UPDATE ItemOrder SET ShippingFee = 0.0 WHERE Custid = :new.CustId;
    ELSIF :new.custType = 'regular' THEN
	UPDATE ItemOrder SET ShippingFee = 10.00 WHERE Custid = :new.CustId;
    END IF;
END changeCustType_trig;
/
Show Errors;

/* Procedure that sets the shippping date in the itemOrder table */
CREATE OR REPLACE PROCEDURE setShippingDate(ordId in ItemOrder.orderId%type, shipDate in ItemOrder.ShippedDate%type)
IS
    l_orderDate ItemOrder.OrderDate%type;
BEGIN
    SELECT OrderDate INTO l_orderDate FROM ItemOrder WHERE orderId = ordId;
    IF (l_orderDate <= shipDate) THEN
	UPDATE ItemOrder SET ShippedDate = shipDate WHERE orderId = ordId;
    ELSE
	DBMS_OUTPUT.PUT_LINE('The Shipping Date cannot be less than the Order Date');
    END IF;
END;
/
Show Errors;

/* Function that computes the total for an order */
CREATE OR REPLACE FUNCTION computeTotal(ordId in ItemOrder.orderId%type)
RETURN NUMBER IS
    l_total StoreItems.price%type;
    l_price StoreItems.price%type;
    l_quantity ItemOrder.noOfItems%type;
    l_shippingFee ItemOrder.ShippingFee%type;
    l_itemId ItemOrder.ItemId%type;
    l_subtotal StoreItems.price%type;
    l_tax StoreItems.price%type;
BEGIN
    SELECT ItemId INTO l_itemId FROM ItemOrder WHERE OrderId = ordId;
    SELECT price INTO l_price FROM StoreItems WHERE ItemId = l_itemId;
    SELECT noOfItems INTO l_quantity FROM ItemOrder WHERE orderId = ordId;
    SELECT ShippingFee INTO l_shippingFee FROM ItemOrder WHERE orderId = ordId;
    
    l_subtotal := l_price * l_quantity;
    
    IF l_shippingFee = 0.00 AND l_subtotal >= 100.00 THEN
	l_subtotal := l_subtotal * 0.90;
    END IF;

    l_tax := l_subtotal * 0.05;
    l_total := l_subtotal + l_shippingFee + l_tax;

    RETURN l_total;
END;
/
Show Errors;

/* Shows the customer details and item order details*/
CREATE OR REPLACE PROCEDURE showItemOrders(cId in ItemOrder.CustId%type, inputDate in ItemOrder.OrderDate%type)
AS
    l_custId Customers.CustId%type;
    l_name Customers.Name%type;
    l_email Customers.Email%type;
    l_address Customers.Address%type;
    
    l_orderId ItemOrder.orderId%type;
    l_itemId ItemOrder.ItemId%type;
    l_title ComicBooks.Title%type;
    l_price StoreItems.price%type;
    l_size Tshirts.ShirtSize%type;
    l_orderDate ItemOrder.OrderDate%type;
    l_shippedDate ItemOrder.ShippedDate%type;
    l_quantity ItemOrder.noOfItems%type;

    l_subtotal StoreItems.price%type;
    l_tax StoreItems.price%type;
    l_shippingFee StoreItems.price%type;
    l_discount StoreItems.price%type;
    l_orderTotal StoreItems.price%type;
    l_totalTotal StoreItems.price%type := 0;

    CURSOR comics IS SELECT OrderId,CustId,ItemId,Title,price,OrderDate,ShippedDate,noOfItems,ShippingFee FROM
    (ItemOrder JOIN ComicBooks USING(ItemId)) JOIN StoreItems USING(ItemId) WHERE CustId = cId AND OrderDate >= inputDate
    ORDER BY CustId;

    CURSOR t_shirts IS SELECT OrderId,CustId,ItemId,ShirtSize,price,OrderDate,ShippedDate,noOfItems,ShippingFee FROM
    (ItemOrder JOIN Tshirts USING(ItemId)) JOIN StoreItems USING(ItemId) WHERE Custid = cId AND OrderDate >= inputDate
    ORDER BY CustId;

BEGIN
    SELECT CustId,Name,Email,Address INTO l_custId,l_name,l_email,l_address FROM Customers WHERE Custid = cId;
    DBMS_OUTPUT.PUT_LINE('CUSTOMER DETAILS:');
    DBMS_OUTPUT.PUT_LINE('Customer ID: '|| l_custId || CHR(10) || 'Name: '|| l_name || CHR(10) || 'Email: '|| l_email);
    DBMS_OUTPUT.PUT_LINE('Address: ' || l_address);
    DBMS_OUTPUT.PUT_LINE(CHR(13));    
 
    DBMS_OUTPUT.PUT_LINE('COMIC BOOK ORDERS:');
    OPEN comics;
    LOOP
	FETCH comics INTO l_orderId,l_custId,l_itemId,l_title,l_price,l_orderDate,l_shippedDate,l_quantity,l_shippingFee;
	EXIT WHEN comics%notfound;

	l_subtotal := l_price * l_quantity;
	IF l_shippingFee = 0.00 AND l_subtotal >= 100.00 THEN
	    l_discount := 0.10;
	ELSE
	    l_discount := 0.00;
	END IF;

	l_discount := l_subtotal * l_discount;
	l_subtotal := l_subtotal - l_discount;
	l_tax := l_subtotal * 0.05;
	l_orderTotal := l_subtotal + l_tax + l_shippingFee;
	l_totalTotal := l_totalTotal + l_orderTotal;
	
	DBMS_OUTPUT.PUT_LINE('Order ID: '|| l_orderId || CHR(10) ||'Item ID: '|| l_itemId || CHR(10) || 
	'Title: '|| l_price || CHR(10) || 'Price: $'|| l_price); 
	DBMS_OUTPUT.PUT_LINE('Date Ordered: ' || l_orderDate || CHR(10) || 'Shipped Date: '|| l_shippedDate);
	DBMS_OUTPUT.PUT_LINE(CHR(13));

	DBMS_OUTPUT.PUT_LINE('PAYMENT DETAILS: ');
	DBMS_OUTPUT.PUT_LINE('Number of Items: '|| l_quantity || CHR(10) || 'Discount: $' || l_discount || CHR(10) || 
	'Shipping Fee: $' || l_shippingFee || CHR(10) || 'Tax: $' || l_tax);
	DBMS_OUTPUT.PUT_LINE('Order Total: $' || l_orderTotal);
	DBMS_OUTPUT.PUT_LINE(CHR(13));

    END LOOP;
    CLOSE comics;

    DBMS_OUTPUT.PUT_LINE('TSHIRT ORDERS:');
    OPEN t_shirts;
    LOOP
	FETCH t_shirts INTO l_orderId,l_custId,l_itemId,l_size,l_price,l_orderDate,l_shippedDate,l_quantity,l_shippingFee;
	EXIT WHEN t_shirts%notfound;

	l_subtotal := l_price * l_quantity;
	IF l_shippingFee = 0.00 AND l_subtotal >= 100.00 THEN
	    l_discount := 0.10;
	ELSE
	    l_discount := 0.00;
	END IF;

	l_discount := l_subtotal * l_discount;
	l_subtotal := l_subtotal - l_discount;
	l_tax := l_subtotal * 0.05;
	l_orderTotal := l_subtotal + l_tax + l_shippingFee;
	l_totalTotal := l_totalTotal + l_orderTotal;
	
	DBMS_OUTPUT.PUT_LINE('Order ID: '|| l_orderId || CHR(10) || 'Item ID: '|| l_itemId || CHR(10) || 'Title: '|| l_price || CHR(10) ||
	'Price: $'|| l_price || CHR(10) || 'Date Ordered: ' || l_orderDate);
	DBMS_OUTPUT.PUT_LINE('Shipped Date: '|| l_shippedDate);
	DBMS_OUTPUT.PUT_LINE(CHR(13));

	DBMS_OUTPUT.PUT_LINE('PAYMENT DETAILS: ');
	DBMS_OUTPUT.PUT_LINE('Number of Items: '|| l_quantity || CHR(10) || 'Discount: $' || l_discount || CHR(10) || 
	'Shipping Fee: $' || l_shippingFee || CHR(10) || 'Tax: $' || l_tax);
	DBMS_OUTPUT.PUT_LINE('Order Total: $' || l_orderTotal);
	
	DBMS_OUTPUT.PUT_LINE(CHR(13));	
    END LOOP;
    CLOSE t_shirts;
    
    DBMS_OUTPUT.PUT_LINE('Grand Total: $' || l_totalTotal);
END;
/
Show Errors;
