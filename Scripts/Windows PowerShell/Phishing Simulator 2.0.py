#!/usr/bin/env python3
"""Educational phishing simulator for cybersecurity awareness training."""

import json
from datetime import datetime
from typing import Dict, List, Any


class PhishingSimulator:
    """Manages the generation and execution of phishing simulation campaigns."""

    def __init__(self) -> None:
        """Initialize phishing simulator with email templates."""
        self.templates: Dict[str, Dict[str, str]] = {
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
        self.results: List[Dict[str, Any]] = []

    def generate_simulation(self, 
                          template_name: str, 
                          recipient_data: Dict[str, str]) -> Dict[str, str]:
        """
        Generate a simulated phishing email from template.

        Args:
            template_name: Name of the template to use
            recipient_data: Dictionary containing recipient information

        Returns:
            Dictionary containing the generated simulation data

        Raises:
            ValueError: If template_name is not found
        """
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
            'training_link': (
                f"https://security-training.example.com/learn/"
                f"{recipient_data['id']}"
            )
        }

        return simulation

    def run_campaign(self, 
                    recipients_file: str, 
                    template_name: str, 
                    output_file: str) -> int:
        """
        Run a phishing simulation campaign.

        Args:
            recipients_file: Path to JSON file containing recipient data
            template_name: Name of the template to use
            output_file: Path to save campaign results

        Returns:
            Number of simulations generated

        Raises:
            FileNotFoundError: If recipients_file doesn't exist
            json.JSONDecodeError: If recipients_file is not valid JSON
        """
        try:
            with open(recipients_file, 'r', encoding='utf-8') as f:
                recipients = json.load(f)
        except FileNotFoundError:
            print(f"Error: Recipients file '{recipients_file}' not found")
            return 0
        except json.JSONDecodeError:
            print(f"Error: '{recipients_file}' contains invalid JSON")
            return 0

        campaign_results = []
        for recipient in recipients:
            try:
                simulation = self.generate_simulation(template_name, recipient)
                campaign_results.append(simulation)
            except KeyError as e:
                print(f"Error: Missing required field {e} for {recipient.get('email', 'unknown')}")
            except Exception as e:
                print(f"Error generating simulation for {recipient.get('email', 'unknown')}: {str(e)}")

        try:
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(campaign_results, f, indent=2)
        except IOError as e:
            print(f"Error saving results to '{output_file}': {str(e)}")
            return 0

        return len(campaign_results)


def main() -> None:
    """Run the phishing simulator from command line arguments."""
    import argparse

    parser = argparse.ArgumentParser(
        description='Educational Phishing Simulation Tool'
    )
    parser.add_argument(
        '--recipients',
        required=True,
        help='JSON file with recipient data'
    )
    parser.add_argument(
        '--template',
        required=True,
        choices=['urgent_invoice', 'password_reset'],
        help='Template to use for simulation'
    )
    parser.add_argument(
        '--output',
        required=True,
        help='Output file for campaign results'
    )

    args = parser.parse_args()

    simulator = PhishingSimulator()
    num_sent = simulator.run_campaign(
        args.recipients,
        args.template,
        args.output
    )
    print(f"Campaign completed. Generated {num_sent} simulations.")


if __name__ == "__main__":
    main()