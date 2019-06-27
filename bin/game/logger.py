import os
import logging
import logging.handlers


TOP_DIR = os.path.dirname(os.path.abspath(__file__))
LOGGER = None


def get_logger():
    """ return the global logger """
    global LOGGER

    if LOGGER is None:
        LOGGER = logging.getLogger("BLB_monitor")
        LOGGER.setLevel(logging.DEBUG)
        formatter = logging.Formatter(
            '%(name)-12s %(asctime)s %(levelname)-8s %(message)s',
            '%a, %d %b %Y %H:%M:%S',
        )
        log_path = os.path.join(TOP_DIR, 'log')
        if not os.path.isdir(log_path):
            os.mkdir(log_path)
        file_handler = logging.handlers.RotatingFileHandler(
            os.path.join(log_path, "log"),
            maxBytes=500000000,
            backupCount=3)
        file_handler.setFormatter(formatter)
        file_handler.setLevel(logging.INFO)
        LOGGER.addHandler(file_handler)
        file_handler = logging.FileHandler(os.path.join(log_path, "err.log"))
        file_handler.setFormatter(formatter)
        file_handler.setLevel(logging.ERROR)
        LOGGER.addHandler(file_handler)

    return LOGGER
