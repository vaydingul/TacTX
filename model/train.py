import torch
import torch.functional as F
from tqdm import trange, tqdm

def train(model, device, dataset, criterion, optimizer, batch_size, epoch):
	model.to(device)
	model.train()

	pbar = tqdm(range(epoch))
	
	correct = 0
	processed = 0

	for epoch_idx in pbar:


		for trial_idx, (train_trial) in enumerate(dataset):
			# get data loader for trial
			train_trial_loader = torch.utils.data.DataLoader(train_trial, batch_size = batch_size, shuffle=False)


			hidden_ = model.init_hidden(batch_size).to(device)
			for batch_idx, (data, target) in enumerate(train_trial_loader):

				data, target = data.to(device), target.to(device)

				# Init
				optimizer.zero_grad()
				# In PyTorch, we need to set the gradients to zero before starting to do backpropragation because PyTorch accumulates the gradients on subsequent backward passes. 
				# Because of this, when you start your training loop, ideally you should zero out the gradients so that you do the parameter update correctly.

				# Predict
				
				
				y_pred, _ = model(data, hidden_)

				# Calculate loss
				loss = criterion(y_pred, target)
				# PyTorch auto-differentiates the loss w.r.t. the parameters of the model for us, so we just need to call backward() to do the job.

				# Backpropagation
				loss.backward()
				optimizer.step()

				# Update pbar-tqdm
				pred = y_pred.argmax(dim=1, keepdim=True)  # get the index of the max log-probability
				correct += pred.eq(target.view_as(pred)).sum().item()
				processed += len(data)

				pbar.set_description(desc= f'Loss={loss.item()} Epoch = {epoch_idx} Batch_idx={batch_idx} Trial_idx={trial_idx} Accuracy={100*correct/processed:0.2f}')


def evaluate(model, device, test_loader):
	model.eval()
	test_loss = 0
	correct = 0
	with torch.no_grad():
		for data, target in test_loader:
			data, target = data.to(device), target.to(device)
			output = model(data)
			test_loss += F.nll_loss(output, target, reduction='sum').item() # sum up batch loss
			pred = output.argmax(dim=1, keepdim=True) # get the index of the max log-probability
			correct += pred.eq(target.view_as(pred)).sum().item()

	test_loss /= len(test_loader.dataset)

	print('\nTest set: Average loss: {:.4f}, Accuracy: {}/{} ({:.2f}%)\n'.format(
		test_loss, correct, len(test_loader.dataset),
		100. * correct / len(test_loader.dataset)))