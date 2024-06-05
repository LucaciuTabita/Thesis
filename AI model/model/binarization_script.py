import os
import cv2
import shutil


def create_directory_structure(source_dir, target_dir):
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)
        print(f"Created target directory: {target_dir}")
    for root, dirs, files in os.walk(source_dir):
        for dir_ in dirs:
            dir_path = os.path.join(root, dir_)
            new_dir_path = dir_path.replace(source_dir, target_dir, 1)
            if not os.path.exists(new_dir_path):
                os.makedirs(new_dir_path)
                print(f"Created directory: {new_dir_path}")


def apply_binarization(image_path):
    image = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)  # Read image in grayscale mode
    if image is None:
        print(f"Failed to read image: {image_path}")
        return None
    binarized_image = cv2.adaptiveThreshold(image, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 11, 2)
    return binarized_image


def process_images(source_dir, target_dir):
    for root, dirs, files in os.walk(source_dir):
        for file_ in files:
            if file_.endswith(('.png', '.jpg', '.jpeg')):
                file_path = os.path.join(root, file_)
                new_file_path = file_path.replace(source_dir, target_dir, 1)
                binarized_image = apply_binarization(file_path)
                if binarized_image is not None:
                    cv2.imwrite(new_file_path, binarized_image)
                    print(f"Processed and saved: {new_file_path}")
                else:
                    print(f"Failed to process {file_path}")


def main():
    source_directory = 'data'
    target_directory = 'data_binarization'

    # Create the target directory structure
    create_directory_structure(source_directory, target_directory)

    # Process the images
    process_images(source_directory, target_directory)
    print("Processing complete.")


if __name__ == "__main__":
    main()
