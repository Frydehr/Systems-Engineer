import random
import argparse
from datetime import datetime
import csv
import json

class PhishingSimulator:
    def __init__(self):
        self.templates = {
            'urgent_invoice': {
                'subject': 'URGENT: Invoice #{invoice_num} Payment Required',
                'sender': 'accounting@{company_domain}',
                'body': '''Dear {name},
                
Please process the attached invoice #{invoice_num} immediately.
Payment is overdue and urgent attention is required.

Best regards,
Accounts Department'''
            },
            'password_reset': {
                'subject': 'Your password will expire in 24 hours',
                'sender': 'it-support@{company_domain}',
                'body': '''Dear {name},

Your account password will expire in 24 hours. 
To prevent account lockout, please verify your credentials:
{link}

IT Support Team'''
            }
        }
        
        self.results = []
        
    def generate_simulation(self, template_name, recipient_data):
        """Generate a simulated phishing email from template"""
        if template_name not in self.templates:
            raise ValueError(f"Template {template_name} not found")
            
        template = self.templates[template_name]
        simulation = {
            'timestamp': datetime.now().isoformat(),
            'recipient': recipient_data['email'],
            'template': template_name,
            'subject': template['subject'].format(**recipient_data),
            'sender': template['sender'].format(**recipient_data),
            'body': template['body'].format(**recipient_data),
            'training_link': f"https://security-training.example.com/learn/{recipient_data['id']}"
        }
        
        return simulation
        
    def run_campaign(self, recipients_file, template_name, output_file):
        """Run a phishing simulation campaign"""
        with open(recipients_file) as f:
            recipients = json.load(f)
            
        campaign_results = []
        for recipient in recipients:
            try:
                simulation = self.generate_simulation(template_name, recipient)
                campaign_results.append(simulation)
            except Exception as e:
                print(f"Error generating simulation for {recipient['email']}: {str(e)}")
                
        # Save results
        with open(output_file, 'w') as f:
            json.dump(campaign_results, f, indent=2)
            
        return len(campaign_results)

def main():
    parser = argparse.ArgumentParser(description='Educational Phishing Simulation Tool')
    parser.add_argument('--recipients', required=True, help='JSON file with recipient data')
    parser.add_argument('--template', required=True, choices=['urgent_invoice', 'password_reset'],
                        help='Template to use for simulation')
    parser.add_argument('--output', required=True, help='Output file for campaign results')
    
    args = parser.parse_args()
    
    simulator = PhishingSimulator()
    num_sent = simulator.run_campaign(args.recipients, args.template, args.output)
    print(f"Campaign completed. Generated {num_sent} simulations.")

if __name__ == "__main__":
    main()