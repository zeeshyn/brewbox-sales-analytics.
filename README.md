# BrewBox Sales Analytics

End-to-end analytics project for a fictional online coffee and tea store,
using Excel, PostgreSQL and Power BI.

> **Note:** the dataset is synthetic and was created for practice.

## Business question
What is driving revenue growth, where is money being lost, and what
should the business do next?

## Data
Four related tables (customers, products, orders, order_items),
Jan 2024 to Dec 2025.

## Tools and skills
- **Excel:** data cleaning (TRIM, PROPER)
- **PostgreSQL:** JOINs, CTEs, window functions (LAG), CASE WHEN, HAVING
- **Power BI:** data model, DAX measures (CALCULATE, DIVIDE), 2-page dashboard

## Key findings
- Revenue grew 43% year over year (1.24M to 1.77M), with a 56% profit margin
- Quarter4 brings in about 38% of annual revenue
- COD return rate is about 13%, roughly 2.4x UPI
- Revenue rank and profit rank differ for several products

## Recommendations
1. Prepare inventory and campaigns before Quarter4
2. Reduce COD returns (confirmation steps, prepaid incentives)
3. Promote high-margin products such as Tea

## Dashboard
![Overview](dashboard/page1_overview.jpeg)
![Deep dive](dashboard/page2_deep_dive.jpeg)

[Full dashboard (PDF)](dashboard/brewbox_dashboard_PDF.pdf)

## Repository contents
- `data/`: the four CSV files
- `sql/`: table definitions and analysis queries
- `dashboard/`: screenshots and PDF export

## Limitations
- Synthetic data, so patterns reflect how it was generated
- Discounts and season overlap, so their effects can't be separatedt.
