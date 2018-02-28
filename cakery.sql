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
