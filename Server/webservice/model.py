# Ji Benassuti dos Santos - AMS1

import sqlite3
from flask import g

DATABASE = './FlyTag.db'

def getDb():
  db = getattr(g, '_database', None)
  if db is None:
    db = g._database = sqlite3.connect(DATABASE)
  return db

# @app.teardown_appcontext
# def close_connection(exception):
#   db = getattr(g, '_database', None)
#   if db is not None:
#     db.close()

def queryDb(query, args=(), one=False):
  cur = getDb().execute(query, args)
  rv = cur.fetchall()
  cur.close()
  return (rv[0] if rv else None) if one else rv