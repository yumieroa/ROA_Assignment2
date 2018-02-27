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
--        insert into orderslip (order_total) values (orderslip.order_quantity * products.prod_price);
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
