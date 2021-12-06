import torch
import torch.functional as F
import tqdm
from . import dataset_util
from . import model_util

def train(model, device, train_loader, optimizer, epoch):
	model.train()
	pbar = tqdm.tqdm(train_loader)
	correct = 0
	processed = 0
	for batch_idx, (data, target) in enumerate(pbar):
		# get samples
		data, target = data.to(device), target.to(device)

		# Init
		optimizer.zero_grad()
		# In PyTorch, we need to set the gradients to zero before starting to do backpropragation because PyTorch accumulates the gradients on subsequent backward passes. 
		# Because of this, when you start your training loop, ideally you should zero out the gradients so that you do the parameter update correctly.

		# Predict
		y_pred = model(data)

		# Calculate loss
		loss = F.nll_loss(y_pred, target)
		# PyTorch auto-differentiates the loss w.r.t. the parameters of the model for us, so we just need to call backward() to do the job.

		# Backpropagation
		loss.backward()
		optimizer.step()

		# Update pbar-tqdm
		pred = y_pred.argmax(dim=1, keepdim=True)  # get the index of the max log-probability
		correct += pred.eq(target.view_as(pred)).sum().item()
		processed += len(data)

		pbar.set_description(desc= f'Loss={loss.item()} Batch_id={batch_idx} Accuracy={100*correct/processed:0.2f}')


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