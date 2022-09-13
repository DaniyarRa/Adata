#import uvicorn
from fastapi import FastAPI
import json as j
from dicttoxml import dicttoxml


app = FastAPI()

@app.get("/transformJson")
def transformJson(q: str):
    xml = dicttoxml(j.loads(q))
    return xml
    
    
    
    

#if __name__  == '__name__':
#    uvicorn.run(app, host='0.0.0.0', port=8000)    