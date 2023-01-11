#Created by Maulana Ariefai (maulana.ariefai60@gmail.com)
#Self studying how to make dynamic website using flask

from flask import Flask, request, render_template, redirect
import qrcode

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/qr_code')
def qr_code():
    return render_template('qr_code.html')

@app.route('/generate', methods=['POST'])
def generate():
    link = request.form['link']
    qr = qrcode.QRCode(version=1, box_size=10, border=5)
    qr.add_data(link)
    qr.make(fit=True)
    img = qr.make_image(fill_color='black', back_color='white')
    img.save("static/img/qrcode.png")
    return redirect('/qr_code')


if __name__ == '__main__':
    app.run(debug=True)