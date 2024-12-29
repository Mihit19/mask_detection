from flask import Flask, request, jsonify
from tensorflow.keras.models import load_model # type: ignore
import numpy as np
import cv2
from tensorflow.keras.preprocessing import image # type: ignore

app = Flask(__name__)

# Load the trained model
model = load_model('models/model_50.h5')

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Get image file from request
        img_file = request.files['image']
        img = image.load_img(img_file, target_size=(124, 124))
        img_array = image.img_to_array(img) / 255.0  # Normalize image
        img_array = np.expand_dims(img_array, axis=0)

        # Predict mask/no mask
        result = model.predict(img_array)
        prediction = 'Mask' if result[0][0] > 0.5 else 'No Mask'

        return jsonify({'prediction': prediction})
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

