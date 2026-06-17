enum DateFilterRange {
  all('All Time'),
  today('Today'),
  yesterday('Yesterday'),
  thisWeek('This Week'),
  thisMonth('This Month'),
  lastMonth('Last Month');

  const DateFilterRange(this.label);
  final String label;
}
