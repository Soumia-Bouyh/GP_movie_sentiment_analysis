from flask import Flask, request, jsonify
from flask_cors import CORS
import pickle
from langdetect import detect
import numpy as np
from transformers import AutoTokenizer
import pandas as pd
import torch
from sentence_transformers import SentenceTransformer
from scipy.special import softmax
from langdetect import detect_langs

def detect_language(text):
    detections = detect_langs(text)
    for detection in detections:
        if detection.lang in ['en', 'ar'] and detection.prob > 0.5:
            return detection.lang
    return None


# Create Flask app
app = Flask(__name__)
CORS(app)  


# Load trained CamelBERT model and tokenizer
with open("camelbert.pkl", "rb") as f:
    camel_bert_model = pickle.load(f)


# Load the tokenizer and model
model_name = 'CAMeL-Lab/bert-base-arabic-camelbert-mix-sentiment'
tokenizer = AutoTokenizer.from_pretrained(model_name)


# Load SentenceTransformer model for English
english_sentence_transformer_model = 'paraphrase-MiniLM-L6-v2'
sentence_transformer_model = SentenceTransformer(english_sentence_transformer_model)

# Load SVM model for English
with open("svm_sentence_transformers.pickle", "rb") as f:
    english_svm_model = pickle.load(f)


@app.route("/analyze_review", methods=['GET', 'POST'])
def process_review():
    # Detect the language of the review
    review = str(request.args.get("review")) 

    language = detect_language(review)
    
    if language == 'ar':
        # Process the review using your trained CamelBERT model
        inputs = tokenizer(review, return_tensors="pt", padding=True, truncation=True)
        outputs = camel_bert_model(**inputs)
        logits = outputs.logits
        probabilities = softmax(logits.detach().numpy(), axis=1)
        sentiment = np.argmax(probabilities)
        sentiment_labels = ['neutral','positive','negative']  # Example sentiment labels
        probability = float(probabilities[0][sentiment])
        
        return jsonify({"sentiment": sentiment_labels[sentiment], "probability": probability})
    
    else :
        # Process the review using Sentence Transformer
        review_embedding = sentence_transformer_model.encode([review])
        sentiment = english_svm_model.predict(review_embedding)[0]
        probabilities = english_svm_model.predict_proba(review_embedding)[0]
        
        return jsonify({"sentiment": sentiment, "probability": max(probabilities)})
    
if __name__ == "__main__":
    app.run(debug=True)
