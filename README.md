# Thesis

The proposed Bachelor's thesis aims to address the challenges consumers face when shopping at thrift stores, especially the lack of fabric composition labels on garments. Thrift stores provide consumers with unique and affordable clothing options and contribute to sustainability by extending the life cycle of used clothing. However, the lack of fabric composition labels represents a significant barrier for consumers, affecting their ability to make informed purchasing decisions and properly care for their clothing.

Without fabric composition labels, thrift store shoppers cannot judge the quality, comfort, and durability of the clothing they plan to purchase. Fabric composition plays a critical role in determining these factors, as certain materials may be more susceptible to wear or may not meet the consumer's preferences or needs. Additionally, the lack of care instructions further complicates matters as consumers may struggle to properly care for their clothing without guidance on washing, drying and ironing methods suitable for specific fabric types.

Solving this problem requires innovative solutions that leverage technology to provide consumers with important substance information. The proposed work aims to develop an AI-based approach that specifically uses convolutional neural networks (CNN) to detect fabric composition in second-hand clothing. By automating the identification process, this study aims to provide consumers with accurate fabric information, improve their shopping experience, and promote sustainability by facilitating informed purchasing decisions and appropriate clothing care practices. The aim of the work is to demonstrate through experimental validation the effectiveness of the proposed solution to accurately identify fabric compositions, thereby contributing to improving the savings experience and promoting sustainable fashion practices.


```mermaid
flowchart TD
    A[Preprocess the Data] --> B[Model Integration]
    B --> C[Evaluation]

    subgraph Preprocess the Data
        A1[Load Data]
        A2[Normalize Images]
    end

    subgraph Model Integration
        B1[Load MobileNetV2]
        B2[Compile Model]
        B3[Train Model]
        B4[Fine-Tune Model]
    end

    subgraph Evaluation
        C1[Evaluate on Validation Set]
        C2[Evaluate on Test Set]
        C3[Generate Confusion Matrix]
    end
```
