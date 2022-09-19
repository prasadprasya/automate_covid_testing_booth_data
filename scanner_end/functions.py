import cv2
import psycopg2


def connection():
    conn = psycopg2.connect(
        host="localhost",
        database="covidbooth",
        user="postgres",
        password="prasad@123")
    cur = conn.cursor()
    # Make some fresh tables using executescript()

    cur.execute('''
        CREATE TABLE IF NOT EXISTS personal_details (
        id serial4 NOT NULL,
        "name" varchar(50) NOT NULL,
        aadhar varchar(50) NOT NULL,
        address varchar(500) NOT NULL,
        mobile varchar(20) NOT NULL,
        created_by varchar(50) NULL,
        created_date timestamp NOT NULL DEFAULT now(),
        modified_by varchar(50) NULL,
        modified_date timestamp NULL,
        excepted_date date NULL,
        CONSTRAINT personal_details_pk PRIMARY KEY (id)
    );
    ''')
    cur.execute('''
            CREATE TABLE IF NOT EXISTS test_details (
            id serial4 NOT NULL,
            person_id int4 NOT NULL,
            "result" int4 NULL,
            lab_name varchar(50) NULL,
            lab_code varchar(50) NULL,
            lab_address varchar(200) NULL,
            message_status int4 NULL DEFAULT 0,
            created_by varchar(50) NULL,
            created_date timestamp NOT NULL DEFAULT now(),
            modified_by varchar(50) NULL,
            modified_date timestamp NULL,
            CONSTRAINT test_details_un UNIQUE (person_id)
        );

        ''')
    conn.commit()
    return conn


def insert_scanned_data():
    # set up camera object
    cap = cv2.VideoCapture(0)
    # QR code detection object
    detector = cv2.QRCodeDetector()
    flag = True
    response = {"status": False}
    while flag:
        # get the image
        _, img = cap.read()
        # get bounding box coords and data
        data, bbox, _ = detector.detectAndDecode(img)
        if data:
            data_string = str(data)
            x = data_string.split("&")
            name, aadhar, address, mobile = x
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
            response["status"] = True
            flag = False

        # display the image preview
        cv2.imshow("code detector", img)
        if cv2.waitKey(1) == ord("q"):
            break
    # free camera object and exit
    cap.release()
    cv2.destroyAllWindows()
    return response


def get_scanned_data():
    # set up camera object
    cap = cv2.VideoCapture(0)
    # QR code detection object
    detector = cv2.QRCodeDetector()
    flag = True
    response = {"status": False}
    while flag:
        # get the image
        _, img = cap.read()
        # get bounding box coords and data
        data, bbox, _ = detector.detectAndDecode(img)
        if data:
            data_string = str(data)
            x = data_string.split("&")
            name, aadhar, address, mobile, profile_img = x
            data_dict = {"name": name, "aadhar": aadhar, "address": address, "mobile": mobile,
                         "profile_img": profile_img}
            response["status"] = True
            response["data"] = data_dict
            flag = False

        # display the image preview
        cv2.imshow("code detector", img)
        if cv2.waitKey(1) == ord("q"):
            break
    # free camera object and exit
    cap.release()
    cv2.destroyAllWindows()
    return response


def fetch_scanned_data():
    # status = insert_scanned_data
    get_query = """
                    SELECT pd.id , pd."name", pd.aadhar, pd.address, pd.mobile, pd.excepted_date , pd.created_date
                    FROM personal_details pd
                """
    conn = connection()
    cur = conn.cursor()
    cur.execute(get_query)
    query_data = cur.fetchall()
    data_list = []
    if query_data:
        for data in query_data:
            data_dict = {"id": data[0], "name": data[1], "aadhar": data[2], "address": data[3], "mobile": data[4],
                         "expected_date": data[5].strftime("%d-%m-%Y") if data[5] else "",
                         "created_date": data[6].strftime("%d-%m-%Y %I:%M %p")}
            data_list.append(data_dict)
    return data_list
