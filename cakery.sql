create table products
(
	prod_name varchar not null
		constraint products_prod_name_pk
			primary key,
	prod_desc varchar,
	prod_price varchar not null
)
;

create table orderslip
(
	order_quantity varchar,
	order_total varchar,
	cust_name varchar not null,
	email varchar not null,
	contact varchar not null,
	address varchar not null,
	prod_name varchar,
	confirmed boolean
)
;

insert into products (prod_name, prod_desc, prod_price) values
('Chocolate Moist', 'Moist chocolate cake covered in chocolate ganache frosting with yema filling.', '700'),
('Chocolate Square', 'Chocolate moist cake covered in chocolate ganache with cherries on top.', '350'),
('Black Forest Cake', 'Chocolate cake with whipped cream covered in chocolate shavings.', '350'),
('Ube Cake', 'Ube cake with whipped cream covered in ube cake crumbs.', '700'),
('Crema de Furta', 'Chiffon cake covered in yema frosting topped with assorted fruits.', '350'),
('Coffee Caramel Cake', 'Coffee-flavored cake covered in whipped cream, topped with caramel syrup', '350'),
('Cassava Cake', 'A Filipino favorite.', '350'),
('Baked Spaghetti', 'Spaghetti smothered in tomato sauce, topped with white sauce and cheese.', '700'),
('Baked Macaroni', 'Macaroni pasta smothered in tomato sauce and topped with white sauce and cheese.', '700'),
('Pineapple Tart', 'Tart filled with delicious pineapple filing.', '35'),
('Buko Tart', 'Tart filled with delicious buko filling.', '30'),
('Torta', 'A filipino soft cake topped with cheese and sugar.', '10'),
('Macaroons', 'Coconut custard pastry.', '3');



create or replace function orderslip(in oprod text, in oqty text, oname text, omail text, ocontact text, oadd text) returns text as
$$
  declare
    loc_res text;

  loc_prod text;
  loc_qty text;
  loc_name text;
  loc_mail text;
  loc_cntct text;
  loc_add text;

  begin
    select into loc_prod prod_name, loc_qty order_quantity, loc_name cust_name, loc_mail email, loc_cntct contact, loc_add address from orderslip;
     if oprod NOTNULL then

       insert into orderslip (prod_name, order_quantity, cust_name, email, contact, address) values (oprod, oqty, oname, omail, ocontact, oadd);
       update orderslip set order_total =  (cast( order_quantity as INT) * 700 )  where prod_name = 'Chocolate Moist';
       update orderslip set order_total =  (cast( order_quantity as INT) * 700 )  where prod_name = 'Chocolate Square';
       update orderslip set order_total =  (cast( order_quantity as INT) * 700 )  where prod_name = 'Black Forest Cake';
       update orderslip set order_total =  (cast( order_quantity as INT) * 700 )  where prod_name = 'Ube Cake';
       update orderslip set order_total =  (cast( order_quantity as INT) * 700 )  where prod_name = 'Crema de Fruta';
       update orderslip set order_total =  (cast( order_quantity as INT) * 700 )  where prod_name = 'Coffee Caramel Cake';
       update orderslip set order_total =  (cast( order_quantity as INT) * 700 )  where prod_name = 'Cassava Cake';
       update orderslip set order_total =  (cast( order_quantity as INT) * 700 )  where prod_name = 'Baked Spaghetti';
       update orderslip set order_total =  (cast( order_quantity as INT) * 700 )  where prod_name = 'Baked Macaroni';
       update orderslip set order_total =  (cast( order_quantity as INT) * 700 )  where prod_name = 'Pineapple Tart';
       update orderslip set order_total =  (cast( order_quantity as INT) * 700 )  where prod_name = 'Buko Tart';
       update orderslip set order_total =  (cast( order_quantity as INT) * 700 )  where prod_name = 'Torta';
       update orderslip set order_total =  (cast( order_quantity as INT) * 700 )  where prod_name = 'Macaroons';
       loc_res = 'ok';
  else
       loc_res = 'Error';
     end if;
     return loc_res;
  end;
$$
 language 'plpgsql';

create or replace function view_cart(out VARCHAR, out VARCHAR, out VARCHAR) returns setof record as
$$

  select prod_name, order_quantity, order_total from orderslip;
$$
 language 'sql';

create or replace function delete_order(in par_del text) returns text as
$$
  declare
    loc_res text;

  begin
     if par_del NOTNULL then
        DELETE from orderslip;
         loc_res = 'ok';
      else
       loc_res = 'Error';
     end if;
     return loc_res;
  end;
$$
 language 'plpgsql';

create or replace function confirmed(in con BOOLEAN) returns text as
$$
 declare
    loc_res text;

    loc_con BOOLEAN;
  begin
    select into loc_con confirmed from orderslip;
     if con NOTNULL then
      update orderslip set confirmed = 'True';
       loc_res = 'ok';
  else
       loc_res = 'Error';
     end if;
     return loc_res;
  end;

$$
 language 'sql';

create or replace function confirmed(in con BOOLEAN) returns text as
$$
  declare
    loc_res text;

  loc_con BOOLEAN;

  begin
    select into loc_con confirmed from orderslip;
     if con NOTNULL then

       update orderslip set confirmed =  'True';
       loc_res = 'ok';
  else
       loc_res = 'Error';
     end if;
     return loc_res;
  end;
$$
 language 'plpgsql';

create or replace function view_det(out VARCHAR, out VARCHAR, out VARCHAR, out VARCHAR, out VARCHAR, out VARCHAR, out VARCHAR) returns setof record as
$$

  select order_quantity, prod_name, order_total, cust_name, email, contact, address from orderslip where confirmed = 'True';
$$
 language 'sql';
