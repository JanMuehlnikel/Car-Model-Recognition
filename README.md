# Car Model Recognition
![Banner](/src/Banner.png)

# Table of Contents
- [Contributors](#contributors)
- [Data](#data)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
- [Usage](#usage)
- [Model Performance](#modelperformance)
- [Contribute](#contribute)
- [License](#license)

# Contributors
![avatar](https://images.weserv.nl/?url=avatars.githubusercontent.com/u/96066381?v=4&h=100&w=100&fit=cover&mask=circle&maxage=7d)  ![avatar](https://images.weserv.nl/?url=avatars.githubusercontent.com/u/96065475?v=4&h=100&w=100&fit=cover&mask=circle&maxage=7d)

[Jan Mühlnikel](https://github.com/JanMuehlnikel)    [Luca Mohr](https://github.com/Luca2732)

# Data
We chose to use the **DVM Car Dataset** (https://deepvisualmarketing.github.io/) to train our models. This dataset contains a great number of images for various car manufacturers and it's models. 
For the training of our model we had to downsize the data because of limited ressources and training time. Therefore we choose to select four of the most popular germany car manufacturers and selected the models represented the most through images in the dataset.

**BMW**  
  ╠ 1 Series  
  ╠ 2 Series  
  ╠ 2 Series Active Tourer  
  ╠ 4 Series Gran Coupe  
  ╠ 5 Series  
  ╠ M4  
  ╠ X3  
  ╠ X5  
  ╚ X6  
**Mercedes-Benz**  
  ╠ A Class  
  ╠ C Class  
  ╚ E Class  
**Porsche**  
  ╠ 911  
  ╚ Macan  
**Volkswagen**  
  ╠ Golf  
  ╠ Passat  
  ╠ Scirocco  
  ╠ Touareg  
  ╚ up!  

(Jingming Huang, Bowei Chen, Lan Luo, Shigang Yue, and Iadh Ounis. (2022). "DVM-CAR: A large-scale automotive dataset for visual marketing research and applications". In Proceedings of IEEE International Conference on Big Data, pp.4130–4137)

[(Back to top)](#table-of-contents)

# iOS App
![iOS1](/app/pictures/7.png)
The Car Model Recognition iOS app, developed using SwiftUI, provides users with the ability to identify car models from images. Users can select a car image, which is then uploaded to a Flask backend server equipped with a trained CNN model. The server processes the image and returns a prediction, which is mapped to the corresponding car model name and displayed in a user-friendly result page. The app features a feedback mechanism, allowing users to rate the prediction's accuracy with thumbs-up or thumbs-down icons. Additionally, the app includes a gallery for viewing previously uploaded images and an information page with details about the project, including a link to the GitHub repository. Navigation is facilitated through a TabView, ensuring smooth transitions between different sections of the app, providing a seamless and intuitive user experience.

## Link to a demo
https://share.icloud.com/photos/0dcMocLHE0rVaYwiFFGFffipQ

[(Back to top)](#table-of-contents)

# Installation
[(Back to top)](#table-of-contents)

# Usage
[(Back to top)](#table-of-contents)

# Model Performance
This table provides a detailed summary of the performance metrics for various models evaluated.

| **Model** | **Epochs** | **Validation Accuracy** | **Recall** |
|:---------:|:----------:|:-----------------------:|:----------:|
| Model 1   | 10         | 85%                     | 80%        |
| Model 2   | 15         | 88%                     | 82%        |
| Model 3   | 20         | 90%                     | 85%        |
| Model 4   | 25         | 87%                     | 83%        |

# License
[(Back to top)](#table-of-contents)
