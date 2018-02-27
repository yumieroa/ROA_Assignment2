#!flask/bin/python
from flask import Flask, url_for, jsonify, request, render_template, send_from_directory, redirect
from flask.ext.httpauth import HTTPBasicAuth
from flask.ext.uploads import UploadSet, configure_uploads, IMAGES
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

@app.route('/mycart', methods=['GET'])
def view_cart():
    res = spcall('view_cart', (), True)

    if 'Error' in str(res[0][0]):
        return jsonify({'status': 'error', 'message': res[0][0]})

    recs = []
    for r in res:
     recs.append({"prod_name": str(r[0]), "order_quantity": str(r[1]), "order_total": str(r[2])})
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

