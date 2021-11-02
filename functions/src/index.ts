import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp()

export const exportQuestions = functions.https.onRequest(async (request, response) => {
    try {
        if (request.method != "POST") {
            response.status(400).send({ message: 'Only POST requests allowed' })
            return
        }
        response.setHeader('Access-Control-Allow-Origin', '*')
        const body = request.body;
        const folder = body['folder']
        const user = body['user']

        const questionsQuery = await admin.firestore().collection(user).doc(folder).collection('questions').get()
        if (questionsQuery.size != 0) {
            var questions = ""
            questionsQuery.forEach(element => {
                const data = element.data()
                questions += `\nQ: ${data['text']}\nA: ${data['answer']['text']}`
            });
            response.status(200).send({
                'bytes': Buffer.from(questions, 'utf-8')
            })
        } else {
            response.status(204).send()
        }
    } catch (e) {
        console.log(e)
        response.status(500).send('An error occured')
    }
})
