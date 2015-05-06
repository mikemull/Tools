import datetime
import pytz
from dateutil.relativedelta import relativedelta

MOUNTAIN_TZ = pytz.timezone('US/Mountain')

def _mountain_today():
    utc_now = datetime.datetime.now(pytz.utc)
    mountain_now = utc_now.astimezone(pytz.timezone('US/Mountain'))
    return mountain_now.replace(hour=0, minute=0, second=0, microsecond=0)


def _months_ago(date, count):
    '''
    Subtracts ``count`` months from ``date``.
    '''
    year, month = date.year, date.month
    year -= count / 12
    count %= 12
    # Wrap to previous year
    if month <= count:
        year -= 1
    # Subtract 1 for modulo offset
    month = (month - count - 1) % 12 + 1
    return datetime.datetime(year, month, 1, tzinfo=MOUNTAIN_TZ)


def _last_saturday_old(ref):
    return ref - datetime.timedelta(days={0: 3, 1: 4, 2: 5, 3: 6, 4: 7, 5: 2, 6: 1}[ref.weekday()])

def _last_saturday_2(ref):
    return ref - datetime.timedelta(days={0: 2, 1: 3, 2: 4, 3: 5, 4: 6, 5: 1, 6: 0}[ref.weekday()])

def _last_saturday(ref):
    return ref - datetime.timedelta(days={0: 2, 1: 3, 2: 4, 3: 5, 4: 6, 5: 0, 6: 1}[ref.weekday()])

def _get_last_quarter_date(from_date=None):

    if not from_date:
        today = datetime.date.today()
    else:
        today = from_date

    quarter_starts = [ datetime.date(today.year,1,1), 
                       datetime.date(today.year,4,1), 
                       datetime.date(today.year,7,1),
                       datetime.date(today.year,10,1)]

    last_quarter_date = quarter_starts[(today.month-1)//3] - relativedelta(days=1)
    
    return '{0}-{1}-{2}'.format(last_quarter_date.year, last_quarter_date.month, last_quarter_date.day)

def weekends(ref):
    saturday = _last_saturday(ref)
    # Convert Mountain time to Salesforce's UTC
    saturday = saturday.astimezone(pytz.utc).replace(tzinfo=None)
    week_ends = [saturday - datetime.timedelta(days=x * 7) for x in range(5)]
    week_ends.reverse()
    return week_ends
