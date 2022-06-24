from scanner_end.functions import connection


def fetch_result_data():
    # status = insert_scanned_data
    get_query = """
                    SELECT pd.id , pd."name", pd.aadhar, pd.address, pd.mobile, pd.excepted_date , pd.created_date, 
                    td.result, td.modified_date
                    FROM test_details as td
                    INNER JOIN personal_details as pd ON td.person_id=pd.id order by person_id ASC;
                """
    conn = connection()
    cur = conn.cursor()
    cur.execute(get_query)
    query_data = cur.fetchall()
    data_list = []
    if query_data:
        for data in query_data:
            result_str = str(data[7])
            result_cls = "active"
            result = ""
            if result_str:
                if result_str == '1':
                    result_cls = "danger"
                    result = "POSITIVE"
                if result_str == '0':
                    result_cls = "success"
                    result = "NEGATIVE"
            data_dict = {"id": data[0], "name": data[1], "aadhar": data[2], "address": data[3], "mobile": data[4],
                         "expected_date": data[5].strftime("%d-%m-%Y") if data[5] else "",
                         "created_date": data[6].strftime("%d-%m-%Y %I:%M %p"), "result_cls":  result_cls,
                         "result": result, "result_date": data[8].strftime("%d-%m-%Y %I:%M %p") if data[8] else ""}
            data_list.append(data_dict)
    return data_list
