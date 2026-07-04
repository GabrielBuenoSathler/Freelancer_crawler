
from telegram import Update
from telegram.ext import ApplicationBuilder, ContextTypes, CommandHandler
import logging
import os
from requisicao import teste
from dotenv import load_dotenv
url ="http://127.0.0.1:8000/vagas_99freelas"

load_dotenv()
APP_ENV = os.getenv('TOKEN')
print (APP_ENV)
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if update.effective_chat is None:
        return
    await context.bot.send_message(chat_id=update.effective_chat.id, text="I'm a bot, please talk to me!")

async def echo(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if update.effective_chat is None or update.message is None or update.message.text is None:
        return
    await context.bot.send_message(chat_id=update.effective_chat.id, text=update.message.text)

async def get_vagas(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if update.effective_chat is None:
        return
    vagas = teste(url)

    for titulo, link in vagas[-10:]:
        await context.bot.send_message(
            chat_id=update.effective_chat.id,
            text=f"{titulo}\n{link}"
        )

if __name__ == '__main__':
    if not APP_ENV:
        raise ValueError('TOKEN environment variable is required')
    application = ApplicationBuilder().token(APP_ENV).build()
    get_vagas_handler = CommandHandler('puxa_vagas',get_vagas)
    start_handler = CommandHandler('start', start)
    echo_handler = CommandHandler('echo',echo)
    
    application.add_handler(start_handler)

    application.add_handler(echo_handler)
    application.add_handler(get_vagas_handler)
    application.run_polling()




