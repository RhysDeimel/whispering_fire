import pytest
from fastapi.testclient import TestClient

from whispering_fire.main import app

client = TestClient(app)


test_data = [(2, 4), (3, 9), (4, 16)]


@pytest.mark.parametrize('given,expected', test_data)
def test_calc_square(given, expected):
    response = client.get(f'/two_pow/{given}')
    assert response.status_code == 200
    assert response.json() == {'result': expected}
