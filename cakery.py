#!flask/bin/python
from flask import Flask, url_for, jsonify, request
from flask_httpauth import HTTPBasicAuth
import sys, os, flask
import model

app = Flask(__name__)
auth = HTTPBasicAuth()

def spcall(qry, param, commit=False):
    try:
        dbo = model.DBconn()
        cursor = dbo.getcursor()
        cursor.callproc(qry, param)
        res = cursor.fetchall()
        if commit:
            dbo.dbcommit()
        return res
    except:
        res = [("Error: " + str(sys.exc_info()[0]) + " " + str(sys.exc_info()[1]),)]
    return res

#orders are saved into the database
@app.route('/orderslip/', methods=['POST'])
def orderslip():

    params = request.get_json()
    prod_name = params["prod_name"]
    order_quantity = params["order_quantity"]
    cust_name = params["cust_name"]
    email = params["email"]
    contact = params["contact"]
    address = params["address"]

    res = spcall('orderslip', (prod_name, order_quantity, cust_name, email, contact, address), True)
    if 'Error' in str(res[0][0]):
        return jsonify({'status': 'error'})

    return jsonify({'status': 'ok'})

#to view orders that are saved into the database
@app.route('/mycart', methods=['GET'])
def view_cart():
    res = spcall('view_cart', (), True)

    if 'Error' in str(res[0][0]):
        return jsonify({'status': 'error', 'message': res[0][0]})

    recs = []
    for r in res:
     recs.append({"prod_name": str(r[0]), "order_quantity": str(r[1]), "order_total": str(r[2])})
    return jsonify({'status': 'ok', 'entries': recs, 'count': len(recs)})

#to cancel order, deletes it from database
@app.route('/delete_order', methods=['POST'])
def delete_order():

    res = spcall("delete_order", ('1'),True)

    return jsonify({'status': 'ok', 'message': res[0][0]})

#confirm order, updates confirmed column to true
@app.route('/confirmed/', methods=['POST'])
def confirmed():

    res = spcall("confirmed", ('1'),True)

    return jsonify({'status': 'ok', 'message': res[0][0]})

#view confirmed orders only
@app.route('/view_det', methods=['GET'])
def view_det():
    res = spcall('view_det', (), True)

    if 'Error' in str(res[0][0]):
        return jsonify({'status': 'error', 'message': res[0][0]})

    recs = []
    for r in res:
     recs.append({"order_quantity": str(r[0]), "prod_name": str(r[1]), "order_total": str(r[2]),"cust_name": str(r[3]),"email": str(r[4]), "contact": str(r[5]), "address": str(r[6])})
    return jsonify({'status': 'ok', 'entries': recs, 'count': len(recs)})

@app.after_request
def add_cors(resp):
    resp.headers['Access-Control-Allow-Origin'] = flask.request.headers.get('Origin', '*')
    resp.headers['Access-Control-Allow-Credentials'] = True
    resp.headers['Access-Control-Allow-Methods'] = 'POST, OPTIONS, GET, PUT, DELETE'
    resp.headers['Access-Control-Allow-Headers'] = flask.request.headers.get('Access-Control-Request-Headers',
                                                                             'Authorization')
    # set low for debugging

    if app.debug:
        resp.headers["Access-Control-Max-Age"] = '1'
    return resp

if __name__ == '__main__':
    app.run(threaded=True)

