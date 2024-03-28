# Ji Benassuti dos Santos - AMS1
from flask_cors import CORS
from flask import Flask, request, session
from secrets import token_hex
from hashlib import sha512
import model as m

app = Flask(__name__)
cors = CORS(app, resources={r"/*": {"origins": "*", "supports_credentials": True}})
app.config['CORS_HEADERS'] = '*'
app.secret_key = 'r8W4awKN*N:CDbVz"w||'

# @app.post("/flutter")
# def flutter():
#   print(request.form)
#   return "", 201

def popSession():
  session.pop('token', None)
  session.pop('admin', None)

def isTokenValid():
  if session.get('token') and app.secret_key in session.get('token'):
    return True
  return False

def isAdmin():
  if isTokenValid() and session.get('admin') == True:
    return True
  return False

# @app.get('/users')
# def users():
#   q = m.queryDb('SELECT * FROM cliente')
#   return q, 200

# @app.route("/tables")
# def hello_world():
#   arr = []
#   for user in m.queryDb(""" SELECT name FROM sqlite_schema 
#                             WHERE type IN ('table','view') 
#                             AND name NOT LIKE 'sqlite_%' 
#                             ORDER BY 1;
#                         """):
#     arr.append(user)
#   return arr

@app.post('/login')
def postLogin():
  email = request.form["email"]
  senha = request.form["senha"]
  grupo = request.form["grupo"] # cliente / funcionario
  q = m.queryDb(f'SELECT * FROM {grupo} WHERE email="{email}" AND senha="{senha}"')
  if q != []:
    session['admin'] = grupo == 'funcionario'
  else:
    return 'Erro', 400

  if not session.get('token'):
    session['token'] = app.secret_key + token_hex()

  return 'Login efetuado com sucesso', 200

@app.post('/logout')
def postLogout():
  popSession()
  return '', 200

@app.put('/register')
def putRegister():
  nome = request.form["nome"]
  email = request.form["email"]
  senha = sha512(b'{request.form["senha"]}').hexdigest()
  data_nasc = request.form["data_nasc"]

  try:
    q = m.queryDb(f'SELECT * FROM cliente WHERE email="{email}"')
    if q == []:
      m.queryDb(f'INSERT INTO cliente(nome, email, senha, data_nasc) VALUES (?,?,?,?)', (nome, email, senha, data_nasc))
      m.queryDb(f'COMMIT')
    else:
      raise Exception
  except:
    return '', 500

  return '', 200

@app.get('/baggage/all')
def getBaggageAll():
  if isAdmin():
    try:
      q = m.queryDb(f'SELECT * FROM mala ORDER BY 1')
      return {
        "malas": q
      }, 200
    except:
      return '', 400
  elif not isTokenValid():
    return 'not allowed', 401
  else:
    return '', 500
  
@app.get('/baggage/loss')
def getBaggageLoss():
  if isAdmin():
    try: 
      q = m.queryDb(f'SELECT * FROM mala WHERE extraviada = 1 ORDER BY 1')
      return {
        "malas": q
      }, 200
    except:
      return '', 400
  elif not isTokenValid():
    return 'not allowed', 401
  else:
    return '', 500