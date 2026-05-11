import tensorflow as tf
import numpy as np

# Dataset bohongan (Dummy Dataset)
# Fitur: [Sayur (0/1), Daging (0/1), Gorengan (0/1), Manis (0/1), Karbohidrat (0/1)]
# Label: 0 = Kurang Sehat, 1 = Sehat
X = np.array([
    [1, 0, 0, 0, 0], # Sayur murni -> Sehat (1)
    [1, 1, 0, 0, 0], # Sayur + Daging rebus -> Sehat (1)
    [0, 1, 1, 0, 0], # Daging goreng -> Kurang Sehat (0)
    [0, 0, 1, 1, 1], # Gorengan manis karbo -> Kurang Sehat (0)
    [1, 0, 1, 0, 0], # Sayur goreng -> Kurang Sehat (0)
    [0, 0, 0, 1, 1], # Manis + Karbo (Kue) -> Kurang Sehat (0)
    [1, 1, 0, 0, 1], # Sayur + Daging + Nasi -> Sehat (1)
    [0, 1, 0, 0, 1], # Daging + Nasi -> Sehat (1)
    [0, 0, 1, 0, 1], # Gorengan + Nasi -> Kurang Sehat (0)
], dtype=np.float32)

y = np.array([1, 1, 0, 0, 0, 0, 1, 1, 0], dtype=np.float32)

# Buat model Keras super sederhana
model = tf.keras.Sequential([
    tf.keras.layers.Dense(8, activation='relu', input_shape=(5,)),
    tf.keras.layers.Dense(1, activation='sigmoid')
])

model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])

# Train model sebentar
model.fit(X, y, epochs=100, verbose=0)

# Uji model
print("Test Sayur Rebus:", model.predict(np.array([[1, 0, 0, 0, 0]], dtype=np.float32)))
print("Test Gorengan Manis:", model.predict(np.array([[0, 0, 1, 1, 1]], dtype=np.float32)))

# Convert ke TFLite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# Simpan model
with open('recipe_classifier.tflite', 'wb') as f:
    f.write(tflite_model)

print("Berhasil membuat recipe_classifier.tflite")
