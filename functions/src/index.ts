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

        const questionsQuery = await admin.firestore().collection(user).doc('folders').collection('folders').doc(folder).collection('questions').get()
        const questions: FirebaseFirestore.DocumentData[] = []
        if (questionsQuery.size != 0) {
            questionsQuery.forEach(element => {
                const data = element.data()
                questions.push(data)
            });
            response.status(200).send(questions)
        } else {
            response.status(204).send()
        }
    } catch (e) {
        console.log(e)
        response.status(500).send('An error occured')
    }
})
export const createUserSettings = functions.auth.user().onCreate((user) => {
    return admin.firestore().collection(user.uid).doc('settings').set({ notificationsSate: 'disabled', runtimeType: 'default' });
})
export const sendNotification = functions.firestore.document('{userId}/folders/folders/{folderId}/questions/{docId}').onCreate(async (snap, contxt) => {
    const notificationData = snap.data()
    
    const settings = await snap.ref.parent.parent?.parent.parent?.parent.doc('settings').get()
    const tokens = settings?.get('notificationTokens') as string[]
    return admin.messaging().sendMulticast({
        tokens: tokens,
        notification: {
            title:notificationData.text,
            body: notificationData.answer.text,
        },
    })
})