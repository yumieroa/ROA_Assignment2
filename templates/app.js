function orderslip() {


	$.ajax(
		{
			url: 'http://127.0.0.1:5000/orderslip/',
			contentType: 'application/json; charset=utf-8',
			data: JSON.stringify({
				'prod_name': $("#prod_name").val(),
				'order_quantity': $("#order_quantity").val(),
				'cust_name': $("#cust_name").val(),
				'email': $("#email").val(),
				'contact': $("#contact").val(),
                'address': $("#address").val()

			}),
			type: "POST",
			dataType: "json",
			error: function (e) {
			},
			success: function (resp) {
                if (resp.status == 'ok') {
                	alert("Successfully added to cart!")
                    window.location.replace('cart.html')

                 }
				else {
					alert("ERROR")
				}

			}
		});
}
function view_cart(){

	 $("#mycart").show();

$.ajax({
    		url: 'http://127.0.0.1:5000/mycart',
    		type: "GET",
    		dataType: "json",
    		success: function(resp) {

				if (resp.status  == 'ok') {
				   for (i = 0; i < resp.count; i++)
                                  {
									   prod_name = resp.entries[i].prod_name;
									   order_quantity = resp.entries[i].order_quantity;
									   order_total = resp.entries[i].order_total;
									   $("#mycart").append(mycart(prod_name,order_quantity, order_total));

                                  }



				} else
				{
                                       $("#mycart").html("");
					alert(resp.message);
				}
    		}
		});
}

function mycart(prod_name,order_quantity,order_total)
{
   return '<div class="col-md-12 col-sm-12 col-xs-12" >' +
       '<p>Product: '+ ' ' +prod_name+  '</p>'+
       '<p>Quantity:'+ ' ' +order_quantity+ '</p>'+
       '<p>Total:'+ ' ' +order_total+ '</p>'+
	'</div>'
}

function del_order() {

	$.ajax(
		{
			url: 'http://127.0.0.1:5000/delete_order',
			contentType: 'application/json; charset=utf-8',
            data: JSON.stringify({
             }),
			type: "POST",
			dataType: "json",
			error: function (e) {
			},
			success: function (resp) {
                if (resp.status == 'ok') {
                alert("Order cancelled!");
                window.location.replace("menu.html")

                 }
				else {
					alert("ERROR")
				}

			}
		});
}