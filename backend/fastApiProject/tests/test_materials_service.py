# tests/test_materials_service.py
import unittest
from services import materials_service
from unittest.mock import patch, MagicMock

class TestCreateMaterial(unittest.TestCase):
    @patch('services.materials_service.base64')
    @patch('services.materials_service.save_file')
    def test_create_material(self, mock_save_file, mock_base64):
        # Arrange
        mock_db = MagicMock()
        mock_material = MagicMock()
        mock_user_id = 1
        mock_base64.b64decode.return_value = b'some data'
        mock_save_file.return_value = 'photos/file'

        # Act
        result = materials_service.create_material(mock_db, mock_material, mock_user_id)

        # Assert
        mock_base64.b64decode.assert_called_once_with(mock_material.image)
        mock_save_file.assert_called_once_with(b'some data', mock_user_id)
        mock_db.add.assert_called_once()
        mock_db.commit.assert_called_once()
        mock_db.refresh.assert_called_once_with(result)