# routers/prediction_router.py
from fastapi import APIRouter, UploadFile, File, HTTPException
import tensorflow as tf
from PIL import Image
import numpy as np
import logging

router = APIRouter()

# Load the model
model = tf.keras.models.load_model('fabric_classification_model_v3.keras')

class_names = ['Acrylic', 'Artificial_fur', 'Artificial_leather', 'Chenille', 'Corduroy', 'Cotton', 'Crepe', 'Denim', 'Felt', 'Fleece', 'Leather', 'Linen', 'Lut', 'Nylon', 'Polyester', 'Satin', 'Silk', 'Suede', 'Terrycloth', 'Velvet', 'Viscose', 'Wool']

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@router.post("/predict/")
async def predict_image(file: UploadFile = File(...)):
    try:
        # Read the image file
        image = Image.open(file.file).resize((160, 160))
        image_array = np.array(image) / 255.0
        image_array = np.expand_dims(image_array, axis=0)

        # Predict
        predictions = model.predict(image_array)
        predicted_class = np.argmax(predictions, axis=1)[0]
        predicted_class_name = class_names[predicted_class]

        return {"predicted_class": predicted_class_name}

    except Exception as e:
        logger.error(f"Error in prediction: {e}")
        raise HTTPException(status_code=500, detail=str(e))