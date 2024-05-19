import unittest
from unittest.mock import patch, MagicMock
from utils import auth
from fastapi import HTTPException
from jose import JWTError

class TestAuth(unittest.TestCase):
    @patch('utils.auth.bcrypt_context')
    @patch('utils.auth.SessionLocal')
    def test_authenticate_user(self, mock_db, mock_bcrypt_context):
        # Arrange
        mock_username = 'testuser'
        mock_password = 'testpassword'
        mock_user = MagicMock()
        mock_user.hashed_password = 'hashedpassword'
        mock_db.query().filter().first.return_value = mock_user
        mock_bcrypt_context.verify.return_value = True

        # Act
        result = auth.authenticate_user(mock_username, mock_password, mock_db)

        # Assert
        self.assertEqual(result, mock_user)
        mock_bcrypt_context.verify.assert_called_once_with(mock_password, mock_user.hashed_password)

    @patch('utils.auth.jwt')
    def test_create_access_token(self, mock_jwt):
        # Arrange
        mock_username = 'testuser'
        mock_user_id = '1'
        mock_expires_delta = MagicMock()
        mock_jwt.encode.return_value = 'testtoken'

        # Act
        result = auth.create_access_token(mock_username, mock_user_id, mock_expires_delta)

        # Assert
        self.assertEqual(result, 'testtoken')
        mock_jwt.encode.assert_called_once()

    @patch('utils.auth.jwt')
    async def test_get_current_user(self, mock_jwt):
        # Arrange
        mock_token = 'testtoken'
        mock_jwt.decode.return_value = {'sub': 'testuser', 'id': '1'}

        # Act
        result = await auth.get_current_user(mock_token)

        # Assert
        self.assertEqual(result, {'username': 'testuser', 'id': '1'})
        mock_jwt.decode.assert_called_once_with(mock_token, auth.SECRET_KEY, algorithms=[auth.ALGORITHM])

    @patch('utils.auth.jwt')
    async def test_get_current_user_jwt_error(self, mock_jwt):
        # Arrange
        mock_token = 'testtoken'
        mock_jwt.decode.side_effect = JWTError('Invalid token', 'test')

        # Act and Assert
        with self.assertRaises(HTTPException):
            await auth.get_current_user(mock_token)

if __name__ == '__main__':
    unittest.main()