from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
from PIL import Image
import io
import numpy as np

app = Flask(__name__)
CORS(app)

# Laden Sie Ihr Modell
model = tf.keras.models.load_model('/Users/lucamohr/GitHub/Car-Model-Recognition/src/models/model_v1.h5')

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
        image = Image.open(io.BytesIO(file.read())).convert('RGB')
        processed_image = preprocess_image(image, target_size=(224, 224))
        prediction = model.predict(processed_image).tolist()

        # Umwandeln der Vorhersage in eine lesbare Form
        predicted_class = np.argmax(prediction[0])

        return jsonify({'prediction': str(predicted_class)})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
