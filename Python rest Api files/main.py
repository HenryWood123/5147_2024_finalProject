import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials
import functions_framework
from flask import Flask, request, jsonify
from datetime import datetime
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# Application Default credentials are automatically created.
cred = credentials.Certificate("serviceKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

app = Flask(__name__)
@functions_framework.http

@app.route('/')
def entry():
    return f"Welcome to this app"


@app.route('/users', methods = ['POST'])
def create_user():
    data = request.json
    user_id = data['user_id']
    user_name = data['user_name']
    email = data['email']
    DOB_str = data['DOB']
    year_group = data['year_group']
    major = data['major']
    onCampus = data['onCampus']
    favorite_food = data['favorite_food']
    favorite_movie = data['favorite_movie']

    DOB = datetime.strptime(DOB_str, '%d/%m/%Y').date().isoformat()

    users_ref = db.collection('Users').document(user_id)

    if users_ref.get().exists:
        return f"{user_id} already exists", 400

    user_data = {
        'user_id': user_id,
        'user_name': user_name,
        'email': email,
        'DOB': DOB,
        'year_group': year_group,
        'major': major,
        'onCampus': onCampus,
        'favorite_food': favorite_food,
        'favorite_movie': favorite_movie
    }

    users_ref.set(user_data)

    return jsonify(user_data)


@app.route('/users/<user_id>', methods=['GET'])
def view_user(user_id):
    doc_name = user_id.strip()
    users_ref = db.collection('Users').document(doc_name)

    try:
        doc = users_ref.get()

        if doc.exists:
            user_data = doc.to_dict()
            user_data['id'] = doc_name
            return jsonify(user_data)
        else:
            return jsonify({'error': f'No such document with ID {doc_name}'}), 404
    except Exception as e:
        return jsonify({'error': f'Error retrieving: {e}'}), 500

@app.route('/users/<user_id>', methods = ['PATCH'])
def edit_user(user_id):
    data = request.json
    doc_name = user_id.strip()
    users_ref = db.collection('Users').document(doc_name)


    if users_ref.get().exists:
        user_data = users_ref.get().to_dict()

        for key in data:
            user_data[key] = data[key]

        users_ref.update(user_data)

        updated_doc = users_ref.get()
        return jsonify(updated_doc)
    else:
        return f"No such document with ID {user_id}"


@app.route('/posts', methods=['POST'])
def create_post():
    data = request.json
    email = data['email']
    post = data['post']



    post_ref = db.collection('Posts').document()
    users_ref = db.collection('Users').where('email', '==', email)
    doc = users_ref.get()


    if len(doc) > 0:
        name = doc[0].to_dict()['user_name']  # Retrieve the user's name from the doc object
        post_data = {
            'email': email,
            'post': post,
            'timestamp': datetime.now().strftime('%H:%M:%S  \n%d/%m/%Y')
        }
        post_ref.set(post_data)

        message = MIMEMultipart()
        message['Subject'] = 'New post created'
        message['From'] = 'henrywd24@gmail.com'
        message['To'] = ', '.join([user.to_dict()['email'] for user in db.collection('Users').get()])
        message.attach(MIMEText(f'Hello,\nA new post has been created by {name}, '
                                f'Open the App to see it!'
                                f'\nThank you!'))

        with smtplib.SMTP('smtp.gmail.com', 587) as smtp:
            smtp.starttls()
            smtp.login('henrywd24@gmail.com', 'fhjijqpsikgdnybc')
            smtp.send_message(message)

        return "Post created successfully", 201
    else:
        return f"Could not find user with email: {email}"

@app.route('/posts', methods=['GET'])
def get_posts():
    posts_ref = db.collection('Posts').order_by('timestamp', direction=firestore.Query.DESCENDING).stream()
 # get all documents in the 'Posts' collection

    # create an empty list to store the results
    posts = []

    # iterate over each document and add it to the list
    for post_doc in posts_ref:
        post = post_doc.to_dict() # convert the document to a dictionary
        posts.append(post)

    return jsonify(posts) # return the list of posts as a JSON response

if __name__ == '__main__':
    app.run(debug=True)