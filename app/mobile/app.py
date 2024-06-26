import os
from flask import Flask, request, jsonify
import tensorflow as tf
from PIL import Image
import io
import numpy as np

app = Flask(__name__)

# Laden Sie Ihr Modell
model = tf.keras.models.load_model('/Users/lucamohr/GitHub/Car-Model-Recognition/src/models/cnn/model_v1.h5')

# Hilfsfunktion zur Bildvorverarbeitung
def preprocess_image(image, target_size):
    image = image.resize(target_size)
    image = np.array(image) / 255.0
    image = np.expand_dims(image, axis=0)
    return image

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400

    try:
        image = Image.open(io.BytesIO(file.read()))
        processed_image = preprocess_image(image, target_size=(128, 128))
        prediction = model.predict(processed_image)
        predicted_class = int(np.argmax(prediction, axis=1)[0])

        response = jsonify({'prediction': predicted_class})
        response.headers.add('Content-Type', 'application/json')
        print(response.get_data(as_text=True))  # Debug-Ausdruck zur Überprüfung der Antwort
        return response
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
