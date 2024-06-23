import tensorflow.keras as keras
from tensorflow.keras.preprocessing.image import load_img, img_to_array
import matplotlib.pyplot as plt
import IPython.display as display
import numpy as np
from tqdm import tqdm
import os

# LOAD IMAGES
def load_images(image_folder, metadata, IMG_HEIGHT, IMG_WIDTH):
    images = []
    labels = []
    for index, row in tqdm(metadata.iterrows(), desc="Processing", total=len(metadata)):
        img_path = os.path.join(image_folder, row['Filename'])
        if os.path.exists(img_path):
            img = load_img(img_path, target_size=(IMG_HEIGHT, IMG_WIDTH))
            img_array = img_to_array(img)
            images.append(img_array)
            labels.append(row['Model'])
    return np.array(images), np.array(labels)

# TRAINING PLOT
class TrainingPlot(keras.callbacks.Callback):
    def __init__(self, MODEL_VERSION):
        self.model_version = MODEL_VERSION

    def on_train_begin(self, logs={}):
        self.losses = []
        self.acc = []
        self.val_losses = []
        self.val_acc = []
        self.logs = []

    def on_epoch_end(self, epoch, logs={}):
        self.logs.append(logs)
        self.losses.append(logs.get("loss"))
        self.acc.append(logs.get("accuracy"))
        self.val_losses.append(logs.get("val_loss"))
        self.val_acc.append(logs.get("val_accuracy"))
        N = np.arange(0, len(self.losses))

        plt.style.use("seaborn")

        # Create a figure with two subplots
        fig, ax = plt.subplots(1, 2, figsize=(14, 5))

        # Plot training and validation loss
        ax[0].plot(N, self.losses, label="train_loss")
        ax[0].plot(N, self.val_losses, label="val_loss")
        ax[0].set_title(f"Training and Validation Loss [Epoch {epoch}]")
        ax[0].set_xlabel("Epoch")
        ax[0].set_ylabel("Loss")
        ax[0].legend()

        # Plot training and validation accuracy
        ax[1].plot(N, self.acc, label="train_acc")
        ax[1].plot(N, self.val_acc, label="val_acc")
        ax[1].set_title(f"Training and Validation Accuracy [Epoch {epoch}]")
        ax[1].set_xlabel("Epoch")
        ax[1].set_ylabel("Accuracy")
        ax[1].legend()

        # Save the figure
        plt.savefig(f"../src/models/training_graphs/training_v{self.model_version}.png")
        plt.close()