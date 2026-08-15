import pytest

import dh_make

@pytest.fixture
def mock_dhlib_path(monkeypatch):
    monkeypatch.setattr('dh_make.__dhlib__', ".")

def check_function_exits(test_function, exit_code=1):
    with pytest.raises(SystemExit) as pytest_wrapped_e:
        test_function()
    assert pytest_wrapped_e.type == SystemExit
    assert pytest_wrapped_e.value.code == exit_code

def test_dhlib_path(mock_dhlib_path):
    dh_make.check_dhlib_path()

def test_dhlib_bad_path(monkeypatch):
    monkeypatch.setattr('dh_make.__dhlib__', "/invalid")
    check_function_exits(dh_make.check_dhlib_path)

def test_get_logname_null(monkeypatch):
    monkeypatch.delenv('LOGNAME',False)
    monkeypatch.delenv('USER', False)
    check_function_exits(dh_make.get_logname)

def test_get_logname_user(monkeypatch):
    monkeypatch.delenv('LOGNAME', False)
    monkeypatch.setenv('USER', 'test_user')
    assert dh_make.get_logname() == 'test_user'

def test_get_logname_logname(monkeypatch):
    monkeypatch.setenv('LOGNAME', 'logname_user')
    monkeypatch.setenv('USER', 'test_user')
    assert dh_make.get_logname() == 'logname_user'

