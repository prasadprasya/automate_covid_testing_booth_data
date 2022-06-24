from flask import Blueprint, request, render_template, make_response
from scanner_end.functions import get_scanned_data, connection, fetch_scanned_data, insert_scanned_data
from lab_end.functions import fetch_result_data
from datetime import datetime
results_app = Blueprint("results", __name__)


def homepage():
    return render_template("home.html")


def scan():
    scanned_data = get_scanned_data()
    return scanned_data


def save_person_details():
    payload = request.json
    name = payload["name"]
    aadhar = payload["aadhar"]
    address = payload["address"]
    mobile = payload["mobile"]
    # gender = payload["radio-buttons"]
    # email = payload["email"]
    # dob = payload["dob"]
    conn = connection()
    cur = conn.cursor()
    cur.execute('''INSERT INTO "personal_details"
                    (name, aadhar, address, mobile) 
                    VALUES (%s, %s, %s, %s) RETURNING id''',
                (name, aadhar, address, mobile))
    conn.commit()
    person_id = cur.fetchone()
    print(person_id)
    cur.execute("""INSERT INTO test_details (person_id)
                                VALUES (%s)""", (person_id,))
    conn.commit()
    cur.close()
    excepted_date = datetime.today()
    response_data = {"status": True, "expected_date": excepted_date}
    return make_response(response_data)


def dashboard():
    data_list = fetch_scanned_data()
    return render_template("dashboard.html", table_data=data_list)


def laboratory():
    data_list = fetch_result_data()
    return render_template("laboratory.html", table_data=data_list)


def lab_result():
    payload = request.json
    result = payload["result"]
    person_id = payload["person_id"]
    conn = connection()
    cur = conn.cursor()
    insert_query = """UPDATE test_details SET result = %s, modified_date = %s WHERE person_id = %s"""
    cur.execute(insert_query, (result, datetime.now(), person_id))
    conn.commit()
    cur.close()
    data_list = fetch_result_data()
    return render_template("laboratory.html", table_data=data_list)


def booth():
    return render_template("booth.html")


results_app.add_url_rule(rule="/", endpoint="homepage", view_func=homepage, methods=["GET"])
results_app.add_url_rule(rule="/booth/", endpoint="booth", view_func=booth, methods=["GET"])
# Scanner End
results_app.add_url_rule(rule="/dashboard/", endpoint="dashboard", view_func=dashboard, methods=["GET"])
results_app.add_url_rule(rule="/scan/", endpoint="scan", view_func=scan, methods=["GET"])
results_app.add_url_rule(rule="/save_person_details/", endpoint="save_person_details", view_func=save_person_details, methods=["POST"])

# Lab End
results_app.add_url_rule(rule="/laboratory/", endpoint="laboratory", view_func=laboratory, methods=["GET"])
results_app.add_url_rule(rule="/lab_result/", endpoint="lab_result", view_func=lab_result, methods=["POST"])
